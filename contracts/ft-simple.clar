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

;; Claim Map
(define-map can-claim principal bool )

;; Read-Only;;
;;;;;;;;;;;;;;

;; Can Claim? 
(define-read-only (get-claim-status (wallet principal))
    (default-to true (map-get? can-claim wallet))
)

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
;; mint Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Free Claim
(define-public (claim-ct)
    (let 
        (
            (current-claim-status (get-claim-status tx-sender))
        ) 
        ;; Assert that current claim status is true
        (asserts! current-claim-status (err "error already claimed"))

        ;; Mint 1 CT to TX-Sender
        (unwrap! (ft-mint? clarity-token u1 tx-sender) (err "err-mint-ft"))
       
        ;; Change claim status of TX-Sender to false
        (ok (map-set can-claim tx-sender false))
    )
)

;; Staking Claim
;; @desc - Function only for mining from staking claims
;; @params - Amount (uint), the amount of tokens earned through staking
(define-public (earned-ct (amount uint)) 
    (let 
        (
          
            (current-supply (unwrap! (get-total-supply) (err "Can't get total supply")))
            (current-remaining-supply (- u100 current-supply))
        ) 

        ;; Assert amount is less than remaining supply
        (asserts! (< amount current-remaining-supply) (err "err no FT mintes left"))

        ;; Assert that contract-caller is .staking-simple
        (asserts! (is-eq contract-caller .staking-simple) (err "err not contract caller"))

        ;; Mint token to tx-sender
       (ok (unwrap! (ft-mint? clarity-token amount tx-sender) (err "err-ft-minting")))
    )
)