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

(define-non-fungible-token advanced-nft uint)

;; (impl-trait .sip-09.nft-traits)

;; Collection Limit
(define-constant collection-limit u10)

;; Root URI
(define-constant collection-root-uri "ipfs://ipfs/QmWRD5DjntwLL8WMDrMHnTVaXX1AtXoNBQouFG7kYHhhPE/")

;; NFT Price 
(define-constant advanced-nft-price u100000000)

;; Collection Index
(define-data-var collection-index uint u1)

;; Admin Deployer
(define-constant deployer tx-sender)

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
(define-public (get-last-token-id) 
    (ok (var-get collection-index))

)

;; Get Token URI

(define-public (get-token-uri (id uint))
    (ok
    (some (concat 
    collection-root-uri 
    (concat 
        (uint-to-ascii id)
        ".json"
        )
        ))
    )
)
;; Get Owner
(define-public (get-owner (id uint)) 
    (ok (nft-get-owner? advanced-nft id))

)

;; Transfer Token
(define-public (transfer (id uint) (sender principal) (recipient principal))
    (begin 
        (asserts! (is-eq tx-sender sender) (err u1))
        (if (is-some (map-get? market id))
            (map-delete market id)
            false
        )
        (nft-transfer? advanced-nft id sender recipient)
        
        )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NON-CUSTODIAL FUNCTIONS;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List in USTX

(define-public (list-in-ustx (item uint) (price uint)) 
    (let 
        (
            (nft-owner (unwrap! (nft-get-owner? advanced-nft item) (err "NFT doesn't exist")))
        )

        ;; Assert that tx-sender is the current owner
        (asserts! (is-eq nft-owner tx-sender) (err "err-not-owner"))

        ;; Map-set & update Market
        (ok (map-set market item {
            price: price,
            owner: tx-sender
        }))
    )
)

;; Unlist in USTX

(define-public (unlist-in-ustx (item uint) (price uint)) 
    (let 
        (
            (current-listing (unwrap! (map-get? market item) (err "err-not-lsited")))
            (current-price (get price current-listing))
            (current-owner (get owner current-listing))
        )

  ;; Assert that tx-sender is the current owner
        (asserts! (is-eq tx-sender current-owner) (err "err-not-owner"))
    
  ;; Delete the listing
  (ok (map-delete market item))
    )
)

;; Buy in USTX

(define-public (buy-in-ustx (item uint))
    (let
         (
            (Current-listing (unwrap! (map-get? market item) (err "err-not-listed")))
            (current-price (get price Current-listing))
            (current-owner (get owner Current-listing))
   
        )
    ;; Send STX to start purchase

    (unwrap! (stx-transfer? current-price tx-sender current-owner) (err "err-stx-transfer"))

    ;; Send NFT to purchaser
    (unwrap! (nft-transfer? advanced-nft item current-owner tx-sender) (err "err-nft-send"))
    
    ;; Delete the listing
    (ok (map-delete market item))

    )
)   


;; Check Listing
(define-read-only (check-listing (item uint)) 
    (map-get? market item)
)

;;;;;;;;;;;;;;;;;;;;;
;; MINT FUNCTIONS ;;;
;;;;;;;;;;;;;;;;;;;;;

;; Mint 1
(define-public (mint-one) 
    (let
        (
            (test true)
            (current-index (var-get collection-index))
            (next-index (+ u1 current-index))
            (whitelist-mints (unwrap! (map-get? whitelist-map tx-sender) (err "err not whitelisted")))

        )

        ;; Assert that collection is not minted out (current-index < collection limit) 
        (asserts! (< current-index collection-limit) (err "err-minted-out"))

        ;; Assert that user has mints left (whitelist mints > 0)
        (asserts! (> whitelist-mints u0) (err "err no mints left"))

        ;; STX Transfer / Pay for the NFT
        (unwrap! (stx-transfer? advanced-nft-price tx-sender deployer) (err "err transfer"))

        ;; Mint NFT to tx-sender
        (unwrap! (nft-mint? advanced-nft current-index tx-sender) (err "err NFT Mint"))

        ;; var-set collection index to next-index
        (var-set collection-index next-index)

        ;; var-set whitelist-mints to whitelist-mints - 1
        (ok (map-set whitelist-map tx-sender (- whitelist-mints u1)))

    )

)

;; Mint 2
(define-public (mint-two) 
    (begin 
        (unwrap! (mint-one) (err "err-mint-1"))
        (unwrap! (mint-one) (err "err-mint-2"))
        (unwrap! (mint-one) (err "err-mint-3"))
        (unwrap! (mint-one) (err "err-mint-4"))
        (ok (unwrap! (mint-one) (err "err-mint-5")))
    )

)


;; Mint 5

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WHITELIST FUNCTIONS ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add to Whitelist
(define-public (whitelist-principal (user principal) (mints uint))
    (let
        (
            (whitelist-mints (unwrap! (map-get? whitelist-map user) (err "err-not-whitelisted")))
        )
            ;; Assert that tx-sender is an admin
            (asserts! (is-some (index-of (var-get admins) tx-sender)) (err "tx-sender is not admin"))

            ;; Assert that whitelist-mint is none (they didn't mint or have no mints)
            (asserts! (is-none (some whitelist-mints)) (err "user already whitelisted"))

            ;; Map set the whitelist-map
            (ok (map-set whitelist-map user mints))
      
    )

)

;; Check Whitelist Status
(define-read-only (whitelist-status (user principal))
    (map-get? whitelist-map user)

)

;;;;;;;;;;;;;;;;;;;;;
;; ADMIN FUNCTIONS;;
;;;;;;;;;;;;;;;;;;;;;

;; Add Admin
(define-public (add-admin (new-admin principal)) 
    (let
        (
            (current-admins (var-get admins))
        )
    
        ;; Assert that tx-sender is admin
        (asserts! (is-some (index-of (var-get admins) tx-sender)) (err "err-not-admin"))

        ;; Assert that new-admin is not already an admin
        (asserts! (not (is-some (index-of (var-get admins) new-admin))) (err "err-not-admin"))

        ;; Var-set admins by appending new-admin
        (ok (var-set admins (unwrap! (as-max-len? (append current-admins new-admin) u10) (err "err-admin'overflow")))))

   )


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

