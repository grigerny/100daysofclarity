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
;; Three states
;; Is-none -> Collection has not been submitted
;; False -> collection has not been approved by admin
;; True -> Collection has been whitelisted by admin
(define-map whitelisted-collections principal bool)

;; Whitelist collection
(define-map collection principal {
    name: (string-ascii 64), 
    royalty-percent: uint, 
    royalty-address: principal, 
    whitelisted: bool
    })

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

;; Helper uint
(define-data-var helper-uint uint u0)



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
;; @descriptions - function that allows a principal to purchase a listed NFT
;; @param - nft-collection:nft-trait, nft-item: uint
(define-public (buy-item (nft-collection <nft>) (nft-item uint)) 
 (let 
      (
        (test true)
        (current-collection (unwrap! (map-get? collection (contract-of nft-collection)) (err "Err Collection")))
        (current-royalty-percent (get royalty-percent current-collection))
        (current-royalty-address (get royalty-address current-collection))
        (current-listing (unwrap! (map-get? item-status {collection: (contract-of nft-collection), item: nft-item}) (err "err-item-not-listed")))
        (current-collection-listings (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-collection-has-no-listing")))
        (current-listing-price (get price current-listing))
        (current-listing-royalty (/ (* current-listing-price current-royalty-percent)))
        (current-listing-owner (get owner current-listing))
      )

      ;; Assert that item is listed
      (asserts! (is-some (index-of current-collection-listings nft-item)) (err "err item not listed"))

      ;; Assert tx-sender is NOT Owner
      (asserts! (not (is-eq tx-sender current-listing-owner)) (err "error-buyer-is-owner"))

      ;; Send STX (price) to owner
      (unwrap! (stx-transfer? current-listing-price tx-sender current-listing-owner) (err "STX not sent"))

      ;; Send STX (royalty) to artist/royalty-address
      (unwrap! (stx-transfer? current-listing-royalty tx-sender current-royalty-address) (err "Error sending royalty payment"))

      ;; Transfer NFT from contract to buyer/NFT
      (unwrap! (contract-call? nft-collection transfer nft-item (as-contract tx-sender) tx-sender ) (err "NFT transfer err"))

      ;; Map-delete item-listing
      (map-delete item-status {collection: (contract-of nft-collection), item: nft-item})

      ;; Filter out nft-item from collection-listing
        (var-set helper-uint nft-item)
        (ok (map-set collection-listing (contract-of nft-collection) (filter remove-uint-from-list current-collection-listings)))
    
      
 )
)   

;; Change royalty address

(define-public (change-royalty-address (nft-collection principal) (new-royalty principal))
    (let 
        (
            (test true)
        ) 
        ;; Assert that collection is whitelisted

        ;; Assert that tx-sender is current royalty-address

        ;; Merge / merge existing collection tuple with new royalty address
        (ok test)
    )
)


;; Owner Funcs ;;
;;;;;;;;;;;;;;;;;

;; List item
;; @description - function that allows an owner to list their NFT
;; @param - collection:<nft-trait>, item: uint
(define-public (list-item (nft-collection <nft>) (nft-item uint) (nft-price uint)) 
    (let 
    (
        (test true) 
        (current-nft-owner (unwrap! (contract-call? nft-collection get-owner nft-item) (err "get owner")))
        (current-collection-listing (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "No collections")))
    ) 

    ;; Assert that TX-Sender is current NFT Owner
    (asserts! (is-eq (some tx-sender) current-nft-owner) (err "TX-Sender is not current NFT Owner"))

    ;; Assert that the collection is whitelisted
    (asserts! (is-some (map-get? collection (contract-of nft-collection))) (err "Collection note whitelisted"))

    ;; Assert item-status is-none
    (asserts! (is-none (map-get? item-status {collection: (contract-of nft-collection), item: nft-item})) (err "item is already listed"))
    
    ;; Transfer NFT from tx-sender to contract
    (unwrap! (contract-call? nft-collection transfer nft-item tx-sender (as-contract tx-sender)) (err "NFT Transfer"))

    ;; Map-set item-status w/new price & owner
    (map-set item-status {collection: (contract-of nft-collection), item: nft-item} 
    {
        owner: tx-sender,
        price: nft-price
    }
    )
    ;; Map-set colletion-listing
    (ok (map-set collection-listing (contract-of nft-collection) (unwrap! (as-max-len? (append current-collection-listing nft-item) u10000) (err "collection listing overflow"))))
   
    )
)

;; Unlist item
(define-public (unlist-item (nft-collection <nft>) (nft-item uint)) 
    (let 

    (
        (test true)
    )

    ;; Assert that the current owner of NFT is Contract
    ;; Assert that item-status is-some
    ;; Assert that the owner from item-status tuple is tx-sender
    ;; Assert that uint is in collection-listing-map
    ;; Transfer NFT back from contract to tx-sender (orginal owner)
    ;; Map-Set collection listing, (remove uint)
    ;; Map-Set item-status (delete entry)

    (ok true)
    )
)

;; Day 71.5 
;; Change price
(define-public (change-price (nft-collection <nft>) (nft-item uint) (nft-price uint)) 
    (let 
        (
            (current-collection-listings (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-collection-has-no-listing")))
            (current-listing (unwrap! (map-get? item-status {collection: (contract-of nft-collection), item: nft-item}) (err "err-item-not-listed")))
            (current-nft-owner (unwrap! (contract-call? nft-collection get-owner nft-item) (err "get owner")))
            (current-listing-owner (get owner current-listing))
       )
            ;; Assert that NFT item is in collection-listing
            (asserts! (is-some (index-of current-collection-listings nft-item)) (err "No item Listed"))

            ;; Assert that NFT current owner is contract
            (asserts! (is-eq (some (as-contract tx-sender)) current-nft-owner) (err "Contract is not owner"))

            ;; Assert that tx-sender is owner from item-status tuple
            (asserts! (is-eq tx-sender current-listing-owner) (err "not listing owner"))

            ;; Map-set merge item-status with new price
            (ok (map-set item-status 
                {collection: 
                    (contract-of nft-collection), item: nft-item} 
                        (merge current-listing {price: nft-price})
                )
            )
    ) 
)

;; Artist Funcs ;;
;;;;;;;;;;;;;;;;;;

;; Submit Collection

(define-public (submit-collection (nft-collection <nft>) (royalty-percent uint) (collection-name (string-ascii 64)))
    (let 
        (
        (test true)  
        )

        ;; Assert that collection is not yet whitelisted by making sure it is-none

        ;; Assert that tx-sender is the deployer of NFT parameter

        ;; Map Set whitelisted-collections to false

         (ok test)
    )
    
)

;; Change royalty address


;; Admin Funcs ;;
;;;;;;;;;;;;;;;;;

;; Accept/reject whitelistng
(define-public (whitelisting-approval (nft-collection principal) (approval-boolean bool)) 
(let 
    (
        (test true)
    ) 

    ;; Assert that whitelisting exists / is-some

    ;; assert that tx-sender is an admin

    ;; Map-set nft-collection with true as whitelisted
        (ok test)
)
) 

;; Add an admin

(define-public (add-admin (new-admin principal)) 
(let 
    (
    (test true)
    ) 
    (ok test)
)

)

;; Remove an admin
(define-public (remove-admin (admin principal)) 
(let 
    (
        (test true)
    ) 

    ;; Assert that tx-sender is admin
    ;; Assert that remove-admin exists
    ;; Var-set helper principal
    ;; Filter out remove-admin
    
        (ok test)
)

)

;; Helper Function ;;

;; Filter remove uint from list
(define-private (remove-uint-from-list (item-helper uint)) 
    (not (is-eq item-helper (var-get helper-uint)))
)