;; Day 51
;; SIP-09 locally so we can work with NFTs correctly
;; Reviewing more clarity fundamentals
;; Written by Gary Riger following 100DaysofClarity by Setzeus / StrataLabs

(define-trait nft-trait
(
    ;; Last token ID
    ;; Get last token ID
    (get-last-token-id () (response uint uint))
    ;; URI metadata
    (get-token-uri (uint) (response (optional (string-ascii 256)) uint))
    ;; Get token owner
    (get-owner (uint) (response (optional principal) uint))
    ;; Transfer NFTs
    (transfer (uint principal principal) (response bool uint))
)
)