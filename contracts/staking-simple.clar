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
                (current-nft-status (unwrap! (map-get? nft-status item) (err "NFT not staked")))
                (current-user-stakes (unwrap! (map-get? user-stakes tx-sender) (err "user has nothing staked")))
                (test true)
            ) 

        ;; assert that item is staked
        (asserts! (is-some (get last-staked-or-claimed current-nft-status)) (err "err NFT Not staked"))


        ;; Check if tx-sender is staker
        ;; GARY ATTEMPT2: (is-eq user-stakes tx-sender)

        ;; Transfer the NFT from contract to staker/tx-sender

        ;; If unclaimed balance > 0
            ;; Send unclaimed balance
            ;; Don't send

        ;; Update the NFT Status Map
        ;; Update user stakes map / unstakes the NFT
    
       (ok test)
        )

    )

    ;; Claim FT Reward
    ;; @desc - Function to claim an  unclaimed claim-token
    ;; @param - Item (uint), NFT Identifier for claiming 
    (define-public (claim-reward (item uint)) 
        (let 
            (
            (test true)
            ) 

        ;; Assert that the item is actively staked


        ;; Assert that claimable balance is > 0


        ;; Assert that tx-sender is staker in the stake-status map
     

        ;; Calculate reward & mint from FT Contract
        
        ;; Update NFT Stake Map

        (ok test)
        )
    )
