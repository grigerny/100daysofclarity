;; Staking - Simple
;; A barebones simple staking contract
;; User stakes "simple-nft" in exchange for "clarity-token"
;; Day 80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants, Variables and Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Always need a map when working with tracking associated data
    ;; Map that keeps track of NFT Status 
    (define-map nft-status uint {staked: bool, last-staked-or-claimed: uint})



;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Core Writing Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Check unclaimed balance

    ;; Check NFT stake status

    ;; Check principal generate rate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Core Writing Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Stake NFT

    ;; UnStake NFT

    ;; Claim FT Reward

