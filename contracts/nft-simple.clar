;; Day 55NFT Simple
;; The most simple NFT
;; Written by Gary Riger following Setzeus 100 Days of Clarity

;; CONS, VARS & MAPS ;;
;;;;;;;;;;;;;;;;;;;;;;;

;;Define NFT
(define-non-fungible-token simple-nft uint)

;;Adhere to SIP09
(impl-trait .sip-09.nft-trait)

;;Collection Limit - If we want it to expand we dont want it to be constant. 
(define-constant collection-limit u100)

;;Collection Index
(define-data-var collection-index uint u1)

;;Root URL
(define-constant collection-root-url "ipfs://ipfs/QmWRD5DjntwLL8WMDrMHnTVaXX1AtXoNBQouFG7kYHhhPE/")

;;NFT Price
(define-constant simple-nft-price u100000)

;; SIP-09 ;;
;;;;;;;;;;;;
(define-public (get-last-token-id)
    (ok (var-get collection-index))    
)

(define-public (get-token-uri (id uint))
   (ok 
     (some (concat 
     collection-root-url
      (concat 
        (uint-to-ascii id)
        ".json"
      ) 
     ))
   )
)

;; Get token owner fuction
(define-public (get-owner (id uint)) 
    (ok (nft-get-owner? simple-nft id))
)

;; Transfer Function

(define-public (transfer (id uint) (sender principal) (recipient principal)) 
    (begin 
        ;; (asserts! (is-eq tx-sender sender) (err u1))
        (nft-transfer? simple-nft id sender recipient)
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Core Functions ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Core MINT Function
;; @desc - core function used for minting 1 NFT

(define-public (mint) 
  (let 
    (
      (current-index (var-get collection-index))
      (next-index (+ current-index u1))
    )

    ;; Assert that current-index is lower than colleciton limit
    (asserts! (< current-index collection-limit) (err "error we are all minted out"))

    ;; Charge tx-sender for simple-NFT
    (unwrap! (stx-transfer? simple-nft-price tx-sender (as-contract tx-sender)) (err "error stax transfer"))

    ;; Mint NFT Simple
    (ok (unwrap! (nft-mint? simple-nft current-index tx-sender) (err "error minting NFT")))
  
  )

)


;; Helper Function ;;
;;;;;;;;;;;;;;;;;;;;;
;; @desc utility function that takes in a unit & returns a string
;; @param value; the unit we're casting into a string to concatenate

;; thanks to Lnow for the guidance
(define-read-only (uint-to-ascii (value uint)) 
(if (<= value u9)
(unwrap-panic (element-at "0123456789" value))
(get r (fold uint-to-ascii-inner
 0x000000000000000000000000000000000000000000000000000000000000000000000000000000
 {v: value, r: ""}
))
)
)

(define-read-only (uint-to-ascii-inner (i (buff 1)) (d {v: uint, r: (string-ascii 39)}))
 (if (> (get v d) u0)
 {
    v: (/ (get v d) u10),
    r: (unwrap-panic (as-max-len? (concat (unwrap-panic (element-at "0123456789" (mod (get v d) u10))) (get r d)) u39))
 }
 d
 )
)

;; Staking Claim
;; @desc - Function only for mining from staking claims
;; @params - Amount (uint), the amount of tokens earned through staking
(define-public (earned-ct) 
    (let 
        (
            (test true)
        ) 

        ;; Assert amount is less than remaining supply
            (ok test)

        ;; Assert that contract-caller is .staking-simple

        ;; Mint token to tx-sender
    )
)