;; Child Will
;; Smart contract that allows parents to create and fund wallets that only gets executed at a very specific time (when child turns 18). 
;; Written by Gary Riger following 100Daysof Clarity


;; CHILD WALLET
;; We will need a Wallet for the child of the parent
;; This is our main map that is created and funded by a parent and only unlockable by an assigned child (principal)
;; We need to consider how many parents and children there are
;; principal -> {child-principal: principal, offspring-dob: uint, balance: ( uint)}

;;Constants, Variables, Maps

;; Create Child Wallet Fee
(define-constant create-wallet-fee u5000000)

;; Add Child Wallet Funds Fee (every time adult increases balance we charge)
(define-constant add-wallet-funds-fee u2000000)

;; Early Withdrawal Fee (10%)
(define-constant early-withdrawal-fee u10000000)

;; Normal withdrawal Fee (2% of whats left of balance)
(define-constant normal-withdrawal-fee u2000000)

;; Minimum wallet amount of 5 STX at initial deposit
(define-constant min-create-wallet-fee u5000000)

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

;;Parent Functions;;

;;Child Functions;;

;;Admin Functions;;


