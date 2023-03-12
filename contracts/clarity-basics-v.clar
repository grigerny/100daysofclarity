;; Clarity Basics IV
;; Reviewing more Clarity fundamentals
;; Writteb by Gary Riger with help from Setzeus / StrataLabs 100DaysofClarity

;; Day 45 - Private functions
(define-read-only (say-hello-read) 
    (say-hello-world)
)

(define-public (say-hello-public) 
   (ok (say-hello-world))
)
(define-private (say-hello-world) 
    "hello-world" 
)

;; Day 46 - Filter 
(define-constant test-list (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10))
(define-read-only (test-filter-remove-smaller-than-5) 
    (filter filter-smaller-than-5 test-list)
)

(define-read-only (test-filter-remove-evens) 
    (filter remove-evens test-list)
)

(define-private (filter-smaller-than-5 (item uint)) 
    (< item u5)
)

(define-private (remove-evens (item uint))
    (not (is-eq (mod item u2) u0))
)