;; Clarity Basics VI
;; Reviewing more Clarity Fundamentals
;; Written by Gary Riger following Setzeus

;; Day 57 - Minting whitelist logic
(define-non-fungible-token test-nft uint)
(define-constant collection-limit u10)
(define-constant admin tx-sender)
(define-data-var collection-index uint u1)

(define-map whitelist-map principal uint)

(define-public (mint)
  (let 
        (
          (current-index (var-get collection-index))
          (next-index (+ u1 current-index))
          (current-whitelist-mints (unwrap! (map-get? whitelist-map tx-sender) (err "err-whitelist-map-none")))        
        )
        
      ;; Asserts that current-index < collection-limit
    (asserts! (< current-index collection-limit) (err "err-no-mints-left"))

    ;; Asserts that this user has mints list
    (asserts! (> current-whitelist-mints u0) (err "white list mints all used"))

    ;; Mint
    (unwrap! (nft-mint? test-nft current-index tx-sender) (err "err minting"))

    ;; Update allocated whitelist mints
    (map-set whitelist-map tx-sender (- current-whitelist-mints u1))

    ;; Increase current index
    (ok (var-set collection-index next-index))

  )
)

;; Add principal to Whitelist
(define-public (whitelist-principal (whitelist-address principal) (mints-allocated uint))
    (begin 

     ;;Asserts that tx-sender is admin
     (asserts! (is-eq tx-sender admin) (err "err-not-admin"))

     ;;Map-set
     (ok (map-set whitelist-map whitelist-address mints-allocated))
 )    
)

;; Day 58 Non-Custodial Functions

(define-map market uint {price: uint, owner: principal})
(define-public (list-in-ustx (item uint) (price uint))
    (let
    (
        (nft-owner (unwrap! (nft-get-owner? test-nft item) (err "err NFT doesn't exist")))
    )

        ;; Asserts that tx-sender is-eq to NFT owner
        (asserts! (is-eq tx-sender nft-owner) (err "Err not owner"))

        ;; Map set market with new NFT
        (ok (map-set market item {price: price, owner: tx-sender}))
    )
)
;; See the NFT
(define-read-only (get-list-in-ust (item uint))
    (map-get? market item)
)

;; When a user unlists their NFT
(define-public (unlist-in-ustx (item uint))
    (ok true)
)

;; When a user lists their NFT
(define-public (buy-in-ustx (item uint))
    (ok true)
)