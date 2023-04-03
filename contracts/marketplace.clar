;; Marketplace
;; Simple NFT Marketplace
;; Written by Gary Riger following Setzeus 100daysofClarity

;;Unique Properties
;; All Custodial
;; Multiple Admins
;; Collection **Have** to be Whitelisted by Admins
;; Only STX (no FT)

;; Selling an NFT Cycle
;; collection is submitted for whitelisting
;; collection is whitelisted or rejected
;; NFT(s) are listed
;; NFT is purchased
;; NFT is listed
;; NFT is purchased
;; STX/NFT is transferred 
;; Listing is deleted


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
;; get all whitelisted items (collections)
(define-read-only (is-collection-whitelisted (nft-collection principal))
    (map-get? whitelisted-collections nft-collection)
)

;; Get all listed items in a collection
(define-read-only (listed (nft-collection principal))
    (map-get? collection-listing nft-collection)
)

;; Get item status
(define-read-only (item (nft-collection principal) (nft-item uint))
    (map-get? item-status {collection: nft-collection, item: nft-item})
)


;; Buyer Funcs;;
;;;;;;;;;;;;;;;;

;; Buy item


;; Owner Funcs ;;
;;;;;;;;;;;;;;;;;

;; List item

;; Unlist item

;; Change price

;; Artist Funcs ;;
;;;;;;;;;;;;;;;;;;

;; Submit Collection

;; Change royalty address


;; Admin Funcs ;;
;;;;;;;;;;;;;;;;;

;; Accept/reject whitelistng

;; Add an admin

;; Remove an admin
