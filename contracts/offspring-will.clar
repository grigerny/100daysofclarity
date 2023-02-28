;; Child Will
;; Smart contract that allows parents to create and fund wallets that only gets executed at a very specific time (when child turns 18). 
;; Written by Gary Riger following 100Daysof Clarity


;; CHILD WALLET
;; We will need a Wallet for the child of the parent
;; This is our main map that is created and funded by a parent and only unlockable by an assigned child (principal)
;; We need to consider how many parents and children there are
;; principal -> {child-principal: principal, offspring-dob: uint, balance: ( uint)}

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

;;READ-ONLY FUNCTIONSm;;

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

;; Create Wallet
;; @desc - Create a new wallet with a parent, no initial deposit, this wallet is designed to be used by child
;; @param - new-child-principal: principal, new-child-dob: uint

(define-public (create-wallet (new-child-principal principal) (new-child-dob uint))
(let (
    ;; local variables go here
    (test true)
    
    ) 
    ;; Make sure that TX-Sender doesn't have any other wallet
         ;; Assert that map-get? child-wallet is-none
    
    ;; Assert that new-child-dob is atleast higher than block-height - 18 years of blocks

    ;; Assert that new-child-principal is not an admin or tx-sender

    ;; Pay create-wallet-fee in stx
    
    ;; Map-set child-wallet
    (ok test)
)
)

;; Fund Wallet
;; @desc - allows anyone to fund an existing wallet
;; @param - parent-principal: principal, amount: uint

(define-public (fund-wallet (parent principal) (amount uint))
    (let 
    (
    
    ;; local variables go here
        (test true)
        (current-child-wallet (unwrap! (map-get? child-wallet parent) (err "Err-no-child-wallet")))
    )

    ;; Assert that amount is higher than min-add-wallet-amount (5 STX)

    ;; Send STX (amount - fee) to contract

    ;; Send stx (fee) to deployer

    ;; Var-set total-fees

    ;; Map-set current child balance by merging
     ;; Function body goes here
        (ok test)
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
    (test true)
    (current-child-wallet   (unwrap! (map-get? child-wallet parent) (err "err-no-child-wallet")))
    )

    ;; Assert that tx-sender is-eq to child-principal
    ;; Assert that block-height is 18 years in block later than child-dob
    ;; Send STX (amount - fee) to contract
    ;; Send stx (fee) to deployer
    ;; Delete Child Map
    ;; Update total earned fees


    (ok true)
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