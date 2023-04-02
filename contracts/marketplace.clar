;; Marketplace
;; Simple NFT Marketplace
;; Written by Gary Riger following Setzeus 100daysofClarity

;;Unique Properties
;; All Custodial
;; Multiple Admins
;; Collection **Have** to be Whitelisted by Admins
;; Only STX (no FT)

;; Selling an NFT Cycle
;; 1. NFT is listed
;; 2. NFT is purchased
;; 3. STX is transferred 
;; 4. NFT is transferred
;; 5. Listing is deleted


;; Conns, Variables and Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define the trait we'll use throughout 
(use-trait nft .sip-09.nft-trait)

;; All Admins
(define-data-var admins (list 10 principal) (list tx-sender)) 

;; Whtelist collections
(define-map whitelisted-collections principal bool)

;; Whitelist collection
(define-map collection principal {
    name: (string-ascii 62), 
    royalty-percent: uint, 
    royalty-address: principal 
                                 }
)

;; List of all for sale in collection
(define-map collection-listing 
    principal 
    (list 10000 uint)
)

;; Item Status
(define-map item-status {collection: principal, item: uint} {
    owner: principal,
    price: uint
})


;; Read Funcs ;;;
;;;;;;;;;;;;;;;;;

;; Owner Funcs ;;
;;;;;;;;;;;;;;;;;

;; Admin Funcs ;;
;;;;;;;;;;;;;;;;;
