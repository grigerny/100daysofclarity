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
    (define-public (stake-nft) 
    (let
        (
         (test u0)
        )

        ;; Assert that user owns the NFT submitted

        ;; Assert that NFT submitted is not already being staked

        ;; Stake NFT Custodially - Transfer NFT from tx-sender to contract 

        ;; update maps ( nft status )

        ;; update maps ( user stakes )

        (ok true)

    )
    )

    ;; UnStake NFT
    ;; @desc - function to unstake a staked NFT
        ;; Check if NFT is staked
        ;; Unstake the NFT
    ;; @param - item uint, NFT identifier for unstaking a staked item

    (define-public (unstake-nft) 
        (let 
            (
                (test true)
            ) 

        ;; assert that item is staked
        ;; GARY ATTEMPT1: (asserts! (nft-status item) (err "Can't find nft status"))

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

