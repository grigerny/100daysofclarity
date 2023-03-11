;; Child Will
;; Smart contract that allows parents to create and fund wallets that only gets executed at a very specific time (when child turns 18). 
;; Written by Gary Riger following 100Daysof Clarity


;; CHILD WALLET
;; We will need a Wallet for the child of the parent
;; This is our main map that is created and funded by a parent and only unlockable by an assigned child (principal)
;; We need to consider how many parents and children there are
;; principal -> {child-principal: principal, child-dob: uint, balance: ( uint)}

;; App Flow
;; 1. Create Wallet
;; 2. Fund Wallet
;; 3. Claim Wallet
    ;; A. Child
    ;; B. Parent/Admin

;;Constants, Variables, Maps

;; Deployer
(define-constant deployer tx-sender)

;; Contract
(define-constant contract (as-contract tx-sender))

;; Create Child Wallet Fee
(define-constant create-wallet-fee u5000000)

;; Add Child Wallet Funds Fee (every time adult increases balance we charge)
(define-constant add-wallet-funds-fee u2000000)

;; Early Withdrawal Fee (10%)
(define-constant early-withdrawal-fee u10000000)

;; Normal withdrawal Fee (2% of whats left of balance)
(define-constant normal-withdrawal-fee u2000000)

;; Minimum wallet amount of 5 STX at initial deposit
(define-constant min-add-wallet-amount u5000000)

;; 18 Years in Blockheight
;; 18 Years * 365 days * 144 blocks/day)
(define-constant eighteen-years-in-block-height (* u18 (* u365 u144)))


;; List of Admins
(define-data-var admins (list 10 principal) (list tx-sender))

;; Total fees earned
(define-data-var total-fees-earned uint u0)

;; Child's Wallet
(define-map child-wallet principal {
    child-principal: principal,
    child-dob: uint,
    balance: uint
 })

;;READ-ONLY FUNCTIONS;;

;; Get Wallet
(define-read-only (get-child-wallet (parent principal)) 
    (map-get? child-wallet parent)
)

;;Get Child Principal
(define-read-only (get-child-wallet-principal (parent principal))
    (get child-principal (map-get? child-wallet parent))
)

;;Get Child Wallet Balance;;
(define-read-only (get-child-wallet-balance (parent principal))
    (default-to u0 (get balance (map-get? child-wallet parent)))
)

;;Get Child DOB
(define-read-only (get-child-wallet-dob (parent principal)) 
    (get child-dob (map-get? child-wallet parent))
)

;;Get Child Wallet Unlock Height
(define-read-only (get-child-wallet-unlock-height (parent principal))
 (let 
        (
        ;; local variables (child dob)
        (child-dob (unwrap! (get-child-wallet-dob parent) (err u0)))
        ) 

        ;; function body
        (ok (+ child-dob eighteen-years-in-block-height))
    )
)

;; Get Total Fees
(define-read-only (get-earned-fees) 
    (var-get total-fees-earned)
)


;; Get STX in Contract

;; Will use "as-contract" and "get-stx-balance"
(define-read-only (get-contract-stx-balance) 
    (stx-get-balance contract)    
)

;;;;;;;;;;;;;;;;;;;;
;;Parent Functions;;
;;;;;;;;;;;;;;;;;;;;

;; Create Wallet ;; 
;; @desc - Create a new wallet with a parent, no initial deposit, this wallet is designed to be used by child
;; @param - new-child-principal: principal, new-child-dob: uint

(define-public (create-wallet (new-child-principal principal) (new-child-dob uint))
(let (
    ;; local variables go here
    (current-total-fees (var-get total-fees-earned))
    (new-total-fees (+ current-total-fees create-wallet-fee))
    (test true)
    
    ) 
    ;; Make sure that TX-Sender doesn't have any other wallet
         ;; Assert that map-get? child-wallet is-none

    (asserts! (is-none (map-get? child-wallet tx-sender)) (err "wallet already exists"))
    
    ;; Assert that new-child-dob is atleast higher than block-height - 18 years of blocks
    ;; (asserts! (> new-child-dob (- block-height eighteen-years-in-block-height)) (err "err-past-18-years"))

    ;; Assert that new-child-principal is not an admin or tx-sender

    (asserts! (or (not (is-eq tx-sender new-child-principal)) (is-none (index-of (var-get admins) new-child-principal)) ) (err "Invalid child prinicipal"))

    ;; Pay create-wallet-fee in stx (5stx)
    (unwrap! (stx-transfer? create-wallet-fee tx-sender deployer) (err "err-stx-transfer"))

    ;; Var-set total-fees
    (var-set total-fees-earned new-total-fees)
    
    ;; Map-set child-wallet
    (ok (map-set child-wallet tx-sender {
        child-principal: new-child-principal,
        child-dob: new-child-dob,
        balance: u0
    }))
)
)

;; Fund Wallet
;; @desc - allows anyone to fund an existing wallet
;; @param - parent principal: principal, amount: uint

(define-public (fund-wallet (parent principal) (amount uint))
    (let 
    (
    
    ;; local variables go here
        (current-child-wallet (unwrap! (map-get? child-wallet parent) (err "Err-no-child-wallet")))
        (current-child-wallet-balance (get balance current-child-wallet))
        (new-child-wallet-balance (+ (- amount add-wallet-funds-fee) current-child-wallet-balance))
        (current-total-fees (var-get total-fees-earned))
        (new-total-fees (+ current-total-fees min-add-wallet-amount))
    )

    ;; Assert that amount is higher than min-add-wallet-amount (5 STX)
    (asserts! (> amount min-add-wallet-amount) (err "err-not-enough-stx"))


    ;; Send STX (amount - fee) to contract
    (unwrap! (stx-transfer?  (- amount add-wallet-funds-fee) tx-sender contract) (err "err-stx-transfer-to-contract"))

    ;; Send stx (fee) to deployer

    (unwrap! (stx-transfer? add-wallet-funds-fee tx-sender deployer) (err "err-stx-transfer-to-deployer"))

    ;; Var-set total-fees-earned
    (var-set total-fees-earned new-total-fees)

    ;; Map-set current child balance by merging with old balance + amount
    (ok (map-set child-wallet parent
        (merge 
            current-child-wallet 
            { balance: new-child-wallet-balance }  
        )
    ))
    )
)

;; (define-map child-wallet principal {
;;  child-principal: principal,
;;   child-dob: uint,
;;    balance: uint
;;  })

;;;;;;;;;;;;;;;;;;;
;;Child Functions;;
;;;;;;;;;;;;;;;;;;;

;; Claim Wallet
;; @desc - allows child to claim wallet once and once only 
;; @param - parent: prinicpal
(define-public (claim-wallet (parent principal))
(let 
    (
        (current-child-wallet (unwrap! (map-get? child-wallet parent) (err "err-no-child-wallet")))
        (current-child (get child-principal current-child-wallet))
        (current-dob (get child-dob current-child-wallet))
        (current-balance (get balance current-child-wallet))
        (current-withdrawal-fee (/ (* current-balance u2) u100))
        (current-total-fees (var-get total-fees-earned))
        (new-total-fees (+ current-total-fees current-withdrawal-fee))
    )

    ;; Assert that tx-sender is-eq to child-principal
    (asserts! (is-eq tx-sender current-child) (err "current-child-not-equal-to-child-principal"))

    ;; Assert that block-height is 18 years in block later than child-dob
    (asserts! (> block-height (+ current-dob eighteen-years-in-block-height)) (err "err-child-dob-not-earlier-than-eighteen-years-in-block-height"))

    ;; Send STX (amount - fee) to contract
    (unwrap! (as-contract (stx-transfer? (- current-balance current-withdrawal-fee) tx-sender current-child)) (err "err-transfer-stx"))

    ;; Send stx (fee) to deployer
    (unwrap! (as-contract (stx-transfer? current-withdrawal-fee tx-sender deployer)) (err "err-sending-stx-deployer"))
    
    ;; Delete Child Map
    (map-delete child-wallet parent)

    ;; Update total earned fees
    (ok (var-set total-fees-earned new-total-fees))
    )
)

;;;;;;;;;;;;;;;;;;;
;;Emergency Claim;;
;;;;;;;;;;;;;;;;;;;


;; Emergency Claim
;; @desc - allow either parent or child or admin to withdrawn all stx (minus emergency withdraw fee), back to parent & remove wallet
;; @param - parent: principal

(define-public (emergency-claim (parent principal))
    (let 
        (
            (test true)
            (current-child-wallet (unwrap! (map-get? child-wallet parent) (err "err-no-child-wallet")))
        )
        ;; Assert that tx-sender parent or tx-sender is one of the admins
        ;; Assert that block-height is less than 18 years from dob
        ;; Send STX (amount - emeregency fee) to child
        ;; Send stx emergency withdrawal fee to deployerr
        ;; Delete Child Map
        ;; Update total fees earned
        
        (ok test)
    )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Parent/Admin Functions;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add Admin
;; @desc - Function to add an admin
;; parem - new-admin: prinicpal

(define-public (add-admin) 
    (let 
    (
        (test true)
        ) 
    ;; Assert that tx-sender is a current admin
    ;; Assert that new-admin does not exist in list of admins
    ;; Append new-admin to list of admins

        (ok test))
)

;; Remove Admin
;; desc - function to remove an admin
;; param - removed-admin: principal

(define-public (remove-admin)
    (let 
    (
        (test true)
    ) 

;; Assert that tx-sender is a current admin

;; Filter remove removed-admin
        (ok test)
    )
)