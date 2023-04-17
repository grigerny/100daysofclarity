;; Staking - Simple
;; A barebones simple staking contract
;; User stakes "simple-nft" in exchange for "clarity-token"
;; Day 80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants, Variables and Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; You always need a map when working with tracking associated data
    ;; Map that keeps track of NFT Status 
    (define-map nft-status uint {staked: bool, last-staked-or-claimed: uint})


    ;; Map that keeps track of all user stakes
    (define-map user-stakes principal (list  100 uint))

;;;;;;;;;;;;;;;;;;;;;;;
;; Private Functions;;;
;;;;;;;;;;;;;;;;;;;;;;;

    ;; A private function that maps from a list of ids to a list of height differences
    (define-private (map-from-ids-to-hight-differences (item uint))
        (let
            (
            (current-item-status (default-to {staked: true, last-staked-or-claimed: block-height} (map-get? nft-status item)))
            (current-item-height (get last-staked-or-claimed current-item-status))
            )
        (- block-height current-item-height)
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

        ;; Assert that user ownes the NFT submitted

        ;; Assert that NFT submitted is not staked

        ;; Stake NFT

        (ok true)

    )
    )

    ;; UnStake NFT

    ;; Claim FT Reward

