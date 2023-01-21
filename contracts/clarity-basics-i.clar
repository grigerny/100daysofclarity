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

;; Day 5 - Advance Operators

(define-read-only (exponent) 
    (pow u2 u3)
)

(define-read-only (square-root) 

    (sqrti u25)
)

(define-read-only (modulo)

    (mod u4 u2)
)

(define-read-only (logTwo) 

    (log2 (* u2 u8))
)

;; Day 6 - Strings
(define-read-only (say-hello) 
    "Hello World"
)

(define-read-only (say-hello-world) 
    (concat "Hello" " World"
)
)

(define-read-only (say-hello-world-name) 
    (concat 
        (concat "Hello" " World,")
         " Gary Riger"
    )
)

;; Day 7 - And/Or
(define-read-only (and-i) 

(and true true)

)

(define-read-only (and-ii) 

(and true false)

)

(define-read-only (and-iii)     
    (and 
        (> u2 u1) 
        (not false) 
        true
    )
)

(define-read-only (or-i) 
(or true false)
)

(define-read-only (or-ii) 
(or (not true) false)
)

(define-read-only (or-iii) 
    (or  
        (< u2 u1) 
        (not true) 
        (and (> u2 u1) true)
    )
)

