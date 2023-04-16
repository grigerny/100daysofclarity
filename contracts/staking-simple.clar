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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Core Writing Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

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

    ;; Check unclaimed balance

    ;; Check NFT stake status

    ;; Check principal generate rate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Core Writing Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Stake NFT

    ;; UnStake NFT

    ;; Claim FT Reward

