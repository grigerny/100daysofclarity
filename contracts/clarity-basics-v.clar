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

;; Day 47 - Lists continued with Map I
(define-constant test-list-string (list "alice" "bob" "carl"))

(define-read-only (test-map-increase-by-one) 
    (map add-by-one test-list)

)
(define-read-only (test-map-double) 
    (map double test-list)
)

(define-read-only (test-map-names) 
    (map hello-name test-list-string))

(define-private (add-by-one (item uint)) 
    (+ item u1)
)

(define-private (double (item uint)) 
    (* item u2)
)

(define-private (hello-name (item (string-ascii 24)))
    (concat "hello " item)
)