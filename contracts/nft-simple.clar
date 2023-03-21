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

(define-public (get-owner (id uint)) 
    (ok (nft-get-owner? simple-nft id))
)

(define-public (transfer (id uint) (sender principal) (recipient principal)) 
    (begin 
        (asserts! (is-eq tx-sender sender) (err u1))
        (nft-transfer? simple-nft id sender recipient)
    )
)

;; Core Mint Functions ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;

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

