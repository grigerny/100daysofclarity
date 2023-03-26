;; NFT Advanced
;; An advanced NFT that has all modern functions required for a high quality NFT project
;; Written by Gary Riger following Setzeus 100DaysofClarity Day 60

;; Unique properties & Features
;; 1. Implement non-custodial marketplace function
;; 2. Implement a whitelist minting system
;; 3. Option to mint 1,2 or 5
;; 4. Multiple Admin System

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS, VARIABLES AND MAPS;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-non-fungible-token advance-nft uint)

;; (impl-trait .sip-09.nft-traits)

;; Collection Limit
(define-constant collectoin-limit u10)

;; Root URI
(define-constant collection-root-uri "ipfs://ipfs/QmWRD5DjntwLL8WMDrMHnTVaXX1AtXoNBQouFG7kYHhhPE/")

;; NFT Price 
(define-constant advanced-nft-price u100000000)

;; Collection Index
(define-data-var collection-index uint u1)

;; Admin List
(define-data-var admins (list 10 principal) (list tx-sender))

;; Marketplace Map
(define-map market uint {
    price: uint,
    owner: principal
})

;; Whitelist Map
(define-map whitelist-map principal uint)


;;;;;;;;;;;;;;;;;;;;;
;; SIP-09 FUNCTIONS;;
;;;;;;;;;;;;;;;;;;;;;

;; Get last token ID

;; Get Token URI

;; Transfer Token

;; Get Owner


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NON-CUSTODIAL FUNCTIONS;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List in USTX

;; Unlist in USTX

;; Buy in USTX

;; Check Listing

;;;;;;;;;;;;;;;;;;;;;
;; MINT FUNCTIONS ;;;
;;;;;;;;;;;;;;;;;;;;;

;; Mint 1

;; Mint 2

;; Mint 5

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WHITELIST FUNCTIONS ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add to Whitelist

;; Check Whitelist Status

;;;;;;;;;;;;;;;;;;;;;
;; ADMIN FUNCTIONS;;
;;;;;;;;;;;;;;;;;;;;;

;; Add Admin

;; Remove Admin

;; Remove Admin Helper

;;;;;;;;;;;;;;;;;;;;;
;; HELPER FUNCTIONS;;
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

