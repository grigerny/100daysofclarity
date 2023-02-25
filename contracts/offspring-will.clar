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

;;Read-only Functions;;

;;Parent Functions;;

;;Child Functions;;

;;Admin Functions;;


