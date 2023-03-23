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