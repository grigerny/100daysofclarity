;; SIP-10 
;; Implementing SIP-10 Locally so we can better understand it
;; Gary Riger following Setzeus 100daysofClarity

;; traits
(define-trait ft-trait 
    (
    ;; Transfer from user (principal) to user (principal)
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
    
    ;; Human readable name of the toke
    (get-name () (response (string-ascii 32) uint))

    ;; Human readable Symbol
    (get-symbol () (response (string-ascii 32) uint))

    ;; Number of decimals used to represent token
    (get-decimals () (response uint uint))

    ;; Balance of FT
    (get-balance (principal) (response uint uint))

    ;; Current Total Supply
    (get-total-supply () (response uint uint))

    ;; Optional Function URI
    (get-token-uri () (response (optional (string-utf8 256)) uint))

    )

    
)
;;

;; token definitions
;; 

;; constants
;;

;; data vars
;;

;; data maps
;;

;; public functions
;;

;; read only functions
;;

;; private functions
;;

