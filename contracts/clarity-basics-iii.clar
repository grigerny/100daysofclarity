
;; Day 20 Lists
;; title: clarity-basics-iii
(define-read-only (list-bool)
    (list true false true)
)

;; principals numbers and strings

(define-read-only (list-nums)
    (list u1 u2 u3)
)

(define-read-only (list-string)
    (list "hello" "world" "Gary")
)

(define-read-only (list-principal) 
    (list tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
)

(define-data-var num-list (list 10 uint) (list u1 u2 u3 u4) )

(define-data-var principal-list (list 5 principal) (list tx-sender 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG))

;; Element-At (index => value)

(define-read-only (element-at-num-list (index uint))
    (element-at (var-get num-list) index)
)

(define-read-only (element-at-principal-list (index uint))
    (element-at (var-get principal-list) index)
) 

;; Index-Of (value => index)
(define-read-only (index-of-num-list (item uint))
    (index-of (var-get num-list) item)
)
(define-read-only (index-of-principal-list (item principal))
    (index-of (var-get principal-list) item)
)

;; Day 21 Lists Continued and Intro to Unwrapping
    (define-data-var list-day-21 (list 5 uint) (list u1 u2 u3 u4))
    (define-read-only (list-length)
        (len (var-get list-day-21))
    )
    (define-public (add-to-list (new-num uint)) 
      (ok 
      (var-set list-day-21
        (unwrap! 
            (as-max-len? (append (var-get list-day-21) new-num) u5)
        (err u0))
      )
      )
    )


;; Day 22 - Unwrapping 
;; Unwrap! -> optionals & response
;; Unwarp-err! -> response
;; Unwrap-panic -> optional & response
;; Unwrap-err-panic -> optional & response
;; Try! -> optionals & response

 (define-public (unwrap-example (new-num uint)) 
      (ok 
      (var-set list-day-21
        (unwrap! 
            (as-max-len? (append (var-get list-day-21) new-num) u5)
        (err "error list at max-len"))
      ))
)

 (define-public (unwrap-panic-example (new-num uint)) 
      (ok (var-set list-day-21
            (unwrap-panic (as-max-len? (append (var-get list-day-21) new-num) u5))
            (err "another error")
        ))
    )

(define-public (unwrap-err-example (input (response uint uint)))
  (ok (unwrap-err! input (err u10)))
)

(define-public (try-example (input (response uint uint)))
  (ok (try! input))
)

;; Day 23 - Default-To / Get
(define-constant example-tuple ( some {
    example-bool: true, 
    example-num: none,
    example-string: none, 
    example-principal: tx-sender
}))

(define-read-only (read-example-tuple1) 
    (default-to {
    example-bool: false, 
    example-num: (some u1),
    example-string: (some "World"), 
    example-principal: tx-sender
} example-tuple)
)

;; Day 24 - Conditionals Continued - Match & If

(define-read-only (if-example (test-bool bool))  
    (if test-bool
    ;; Evaluates to true
    "Evaluates to true"
    ;; Evaluates to false
    "Evaluates to false"
    )
)
    
(define-read-only (if-example-num (num uint))
    (if (and (> num u0) (< num u10)) 
    ;; Evaluates to true
    num
    ;; Evaluates to false
    u10
    )
)

(define-read-only (match-optional-some)
(match (some u1) 
    ;; Some value / there was some optional
    match-value (+ u1 match-value) 
    ;; None value / there was no optional
    u0
)
)

(define-read-only (match-optional (test-value (optional uint)))
(match test-value
 match-value (+ u2 match-value) 
u0
)
)
(define-read-only (match-response (test-value (response uint uint)))
    (match test-value
        ok-value ok-value
        err-value u0
    )
)

;; Day 25 - Maps
(define-map first-map principal (string-ascii 24)) 
(define-public (set-first-map (username (string-ascii 24)))
    (ok (map-set first-map tx-sender username))
)

(define-read-only (get-first-map (key principal))
    (map-get? first-map key)
)

(define-map second-map principal {
    username: (string-ascii 48),
    balance: uint,
    referral: (optional principal)
}
)

(define-public (set-second-map (new-username (string-ascii 24)) (new-balance uint) (new-referral (optional principal)))
    (ok (map-set second-map tx-sender {
    username: new-username,
    balance: new-balance,
    referral: new-referral
    }))
)

 ;;Day 26 - Maps Cont.
(define-public (insert-first-map (username (string-ascii 24)))
    (ok (map-insert first-map tx-sender username))
)

(define-map third-map  { user: principal, cohort: uint } {
    username: (string-ascii 24),
    balance: uint,
    referral: (optional principal)
}
)

(define-public (set-third-map (new-username (string-ascii 24)) (new-balance uint) (new-referral (optional principal))) 
    (ok (map-set third-map { user: tx-sender, cohort: u1} {
    username: new-username,
    balance: new-balance,
    referral: new-referral
    }))
)

(define-public (delete-third-map )
   (ok  (map-delete third-map { user: tx-sender, cohort: u1}))
)

(define-read-only (read-third-map) 
   (ok  (map-get? third-map { user: tx-sender, cohort: u1}))
)

