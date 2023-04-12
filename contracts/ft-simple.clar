;; Day 77
;; Simple FT
;; Our very first FT implementation

;; FT - Clarity Token, Supply of 100
;; Every principal can claim 1 CT, once. 

(impl-trait .sip-10.ft-trait)

;; Constants, Variabls & Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define Fungible Token
(define-fungible-token clarity-token u100)

;; Human readable name
;; This line simply defins a name for the token
(define-constant name "clarity Token")

;; Human readable symbol
;; This provides the symbol
(define-constant symbol "CT")

;; Token decimals
(define-constant decimals u0)

;;;;;;;;;;;;
;; SIP-10 ;;
;;;;;;;;;;;;

;; Transfer
(define-public (transfer (amount uint) (sender principal) (recipient principal) (note (optional (buff 34)))) 
    (ft-transfer? clarity-token amount sender recipient)
)

;; Get Token Name
(define-public (get-name)
    (ok name)
)

;; Get Symbol
(define-public (get-symbol)
    (ok symbol)
)

;; Get Decimals
(define-public (get-decimals) 
    (ok decimals)
)

;; Get Balance of FT
(define-public (get-balance (wallet principal)) 
    (ok (ft-get-balance clarity-token wallet))
)

;; Get Token URI
(define-public (get-token-uri) 
    (ok none)
) 

;; Get Total Supply
(define-public (get-total-supply) 
    (ok (ft-get-supply clarity-token))
)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; READ ONLY FUNCTIONS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;
