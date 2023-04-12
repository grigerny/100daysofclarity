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
    (let
    (
        (current-listing (unwrap! (map-get? market item) (err "err-listing-doesn't-exist")))
         (current-price (get price current-listing))
         (current-owner (get owner current-listing))
    )
    ;; Asserts that TX-sender is the owner
    (asserts! (is-eq tx-sender current-owner) (err "err-not-owner"))

    ;; Map delete existing listing
    (ok (map-delete market item))

    )
)

;; When a user lists their NFT
(define-public (buy-in-ustx (item uint))
    (let 
    (
      (current-listing (unwrap! (map-get? market item) (err "err-listing-doesnt-exist")))
      (current-price (get price current-listing))
      (current-owner (get owner current-listing))
    )

    ;; tx-sender buys by transferring stx
    (unwrap! (stx-transfer? current-price tx-sender current-owner) (err "err stx transfer"))

    ;; transfer NFT to buyer
    (unwrap! (nft-transfer? test-nft item current-owner tx-sender) (err "err nft transfer"))

    ;; map-delete the listing
    (ok (map-delete market item))
  )
)

;; Day 66 - Use-Trait to make dynamic contract calls
(use-trait nft .sip-09.nft-trait)

;; Get last ID Function
(define-public (get-last-id (nft-principal <nft>)) 
  (contract-call? nft-principal get-last-token-id)
)

;; Get Owner
(define-public (get-owner (nft-principal <nft>) (item uint)) 
  (contract-call? nft-principal get-owner item)
)

;; Day 76 - Native Fungible Token (FT) Functions
(define-fungible-token test-token u100)
(define-public (mint-test-token) 
  (ft-mint? test-token u1 tx-sender)
)

(define-read-only (get-test-token-balance (user principal)) 
  (ft-get-balance test-token user)
)

(define-read-only (get-test-token-supply) 
  (ft-get-supply test-token)
)

(define-public (transfer-test-token (amount uint) (recipient principal))
  (ft-transfer? test-token u1 tx-sender recipient)
)

(define-public (burn-test-token (amount uint) (sender principal))
  (ft-burn? test-token amount sender)
)

;; Day 77
