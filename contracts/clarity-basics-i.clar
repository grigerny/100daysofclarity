;; Clarity Basics I
;; Day 3 - Booleans, Principals & Read-Only
;; Day 4 - UInts, Ints, & Simple Operators


;; Day 4

(define-read-only (add) 
(+ u1 u1)
)
(define-read-only (subtract) 
(- 1 2)
)
(define-read-only (multiply) 
    (* u3 u2)
)
(define-read-only (divide) 
    (/ u6 u2)
)

(define-read-only (uint-to-int) 
    (to-int u4)
)

(define-read-only (int-to-uint) 
    (to-uint 4)
)