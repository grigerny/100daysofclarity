;; Staking - Simple
;; A barebones simple staking contract
;; User stakes "simple-nft" in exchange for "clarity-token"
;; Day 80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants, Variables and Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; You always need a map when working with tracking associated data
    ;; Map that keeps track of NFT Status 
    (define-map nft-status uint {last-staked-or-claimed: (optional uint), staker: principal})


    ;; Map that keeps track of all user stakes
    (define-map user-stakes principal (list  100 uint))

    ;; Helper variable to remove a uint
    (define-data-var helper-uint uint u0)

;;;;;;;;;;;;;;;;;;;;;;;
;; Private Functions;;;
;;;;;;;;;;;;;;;;;;;;;;;

    ;; A private function that maps from a list of ids to a list of height differences
    (define-private (map-from-ids-to-hight-differences (item uint))
        (let
            (
            (current-item-status (default-to {last-staked-or-claimed: (some block-height), staker: tx-sender} (map-get? nft-status item)))
            (current-item-height (get last-staked-or-claimed current-item-status))
            )
        (- block-height (default-to u0 current-item-height))
    )
    )

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Check unclaimed balance
;; Some sort of check mechanism - bool (yes/no) or uint (0/1)
;; Some sort of balance


(define-read-only (get-unclaimed-balance) 
    (let 
    
        (
            (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "err-there-are-no-stakes")))
            (current-user-height-differences (map map-from-ids-to-hight-differences current-user-stakes))
        )   

    (ok (fold + current-user-height-differences u0))
    
    )
)


    ;; Check NFT stake status
    ;; @desc - Read only function that gets the current stake status map aka NFT status 
    ;; @param - item (uint), NFT identifier that allows us to check status

    (define-read-only (nft-stake-status (item uint))
        (map-get? nft-status item)
    )

    ;; Check principal reward rate
    ;; @desc - Read only function that gets the current total reward rate for tx-sender
    (define-read-only (get-reward-rate)
        (len (default-to (list ) (map-get? user-stakes tx-sender)))
    )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Core Writing Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Stake NFT
    ;; @desc - Function to stake an unstaked nft item
    ;; @param - item (uint), NFT identifier for item submitted for staking
    (define-public (stake-nft (item uint)) 
    (let
        (
            (current-nft-owner (unwrap! (contract-call? .nft-simple get-owner item) (err "item not minted")))
            (current-user-stakes (default-to (list ) (map-get? user-stakes tx-sender)))
            
        )

        ;; Assert that user owns the NFT submitted
        (asserts! (is-eq (some tx-sender) current-nft-owner) (err "Err not NFT Owner"))

        ;; Assert that NFT submitted is not already being staked
            ;; Assert (asserts! () (err "NFT is already being staked"))
            ;; NFT that is being submitted (do we have this?) "(asserts! (last-staked-or-claimed))"
            ;; Not being staked
        (asserts! (or
        (is-none (map-get? nft-status item))
            (is-none (get last-staked-or-claimed (default-to {last-staked-or-claimed: none, staker: tx-sender} (map-get? nft-status item))))
        ) 
        (err "err NFT already staked"))

        ;; Stake NFT Custodially - Transfer NFT from tx-sender to contract 
        (unwrap! (contract-call? .nft-simple transfer item tx-sender (as-contract tx-sender)) (err "error transferring NFT"))

        ;; update maps ( nft status )
        (map-set nft-status item {last-staked-or-claimed: (some block-height), staker: tx-sender})

        ;; update maps ( user stakes )
        (ok (unwrap! (as-max-len? (append current-user-stakes item) u100) (err "user-stakes-overflow")))

   

    )
    )

    ;; UnStake NFT
    ;; @desc - function to unstake a staked NFT
        ;; Check if NFT is staked
        ;; Unstake the NFT
    ;; @param - item uint, NFT identifier for unstaking a staked item

    (define-public (unstake-nft (item uint)) 
        (let 
            (
                (current-tx-sender tx-sender)
                (current-nft-status (unwrap! (map-get? nft-status item) (err "NFT not staked")))
                (current-nft-status-last-height (unwrap! (get last-staked-or-claimed current-nft-status) (err "error can't get last staked or claimed" )))
                (current-balance (- block-height current-nft-status-last-height))
                (current-nft-staker (get staker current-nft-status))
                (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "user has nothing staked")))
            ) 

        ;; assert that item is staked
        (asserts! (is-some (get last-staked-or-claimed current-nft-status)) (err "err NFT Not staked"))


        ;; Check if tx-sender is staker
        (asserts! (is-eq tx-sender current-nft-staker) (err "err not staker"))

        ;; Transfer the NFT from contract to staker/tx-sender
        (unwrap! (as-contract (contract-call? .nft-simple transfer item tx-sender current-tx-sender)) (err "transferring NFT Error"))

        ;; Send unclaimed balance
        (unwrap! (contract-call? .ft-simple transfer item tx-sender (current-tx-sender)) (err "Can't send unclaimed balance"))

        ;; Delete NFT Status Map
        (map-delete nft-status item)

        ;; Update the helper uint
        (var-set helper-uint item)

        ;; Update user stakes map / unstakes the NFT
        (ok (map-set user-stakes current-tx-sender (filter filter-remove-uint current-user-stakes)))
    

        )

    )

    ;; Filter helper function to remova an ID from user-stakes
    (define-private (filter-remove-uint (item uint)) 
        (not (is-eq item (var-get helper-uint)))
    )

    ;; Claim FT Reward
    ;; @desc - Function to claim an  unclaimed claim-token
    ;; @param - Item (uint), NFT Identifier for claiming 
    (define-public (claim-reward (item uint)) 
        (let 
            (
                (current-nft-status (unwrap! (map-get? nft-status item) (err "NFT not staked")))
                (current-nft-status-last-height (unwrap! (get last-staked-or-claimed current-nft-status) (err "error can't get last staked or claimed" )))
                (current-balance (- block-height current-nft-status-last-height))
                (current-nft-staker (get staker current-nft-status))
                (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "user has nothing staked")))
            ) 


        ;; Assert that claimable balance is > 0
        (asserts! (> current-balance u0) (err "Err Nothing to claim"))

        ;; Assert that tx-sender is staker in the stake-status map
        (asserts! (is-eq tx-sender current-nft-staker) (err "err-not-staker"))

        ;; send unclaimed balance
        (unwrap! (contract-call? .ft-simple earned-ct) (err "Can't send unclaimed balance"))
        
        ;; Update NFT Stake Map
        (ok (map-set nft-status item {last-staked-or-claimed: (some block-height), staker: tx-sender}))

        )
    )
