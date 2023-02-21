
;; title: clarity-basics-iv
;; Reviewing more Clarity Fundamentals
;; Written by Setzeus / StrataLabs

;; Day 26.5 - Let 
(define-data-var counter uint u0)
(define-map counter-history uint { user: principal, count: uint })

(define-public (increase-count-begin (increase-by uint)) 
    (begin

        ;; Assert that tx-sender is not previous counter-history user
        (asserts! (not (is-eq (some tx-sender) (get user (map-get? counter-history (var-get counter ))))) (err u0))

        ;; Var-set counter-history
        (map-set counter-history (var-get counter) {
        user: tx-sender,
        count: (+ increase-by (get count (unwrap! (map-get? counter-history (var-get counter)) (err u1))))
        })

        ;;var-set increase-counter 
        (ok (var-set counter (+ (var-get counter) u1)))
    )
)

(define-public (increase-count-let (increase-by uint))
    (let 
        (
            ;; local vars
            (current-counter (var-get counter))
            (current-counter-history (default-to {user: tx-sender, count: u0} (map-get? counter-history current-counter)))
            (previous-counter-user (get user current-counter-history))
            (previous-count-amount (get count current-counter-history))
        )
            ;; Assert that tx-sender is *not* previous counter-history user
            (asserts! (not (is-eq tx-sender previous-counter-user)) (err u0))

            ;; Assert Counter History
            (map-set counter-history current-counter {
                user: tx-sender,
                count: (+ increase-by previous-count-amount)
            })
           
           ;;Var set increaes counter
           (ok (var-set counter (+ u1 current-counter))))
        
    )

    ;; Day 33 - StxTransfer
     (define-public (send-stx-single) 
     (stx-transfer? u1000000 tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
     )
     (define-public (send-stx-double) 
        (begin  
         (unwrap! (stx-transfer? u1000000 tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5) (err u1))
         (stx-transfer? (/ u1000000 u10) tx-sender 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
        )
     )

     ;; Day 34 - stx-get-balance & Burn
     ;; stx-get-balance

     (define-read-only (balance-of) 
        (stx-get-balance tx-sender)
     )

     (define-public (send-stx-balance)
        (stx-transfer? (stx-get-balance tx-sender) tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
     )

     (define-public (burn-some (amount uint))
     (stx-burn? amount tx-sender)
     )

     (define-public (burn-half-of-balance) 
        (stx-burn? (/ (stx-get-balance tx-sender) u2) tx-sender)
     )