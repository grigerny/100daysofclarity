
;; title: clarity-basics-ii

;; Day 8 - Optionals & Parameters
(define-read-only (show-some-i) 
    (some u2)
)

(define-read-only (show-none-i) 
    none
)

(define-read-only (params (num uint) (string (string-ascii 48)) (boolean bool))
    num
) 

(define-read-only (params-optional (num (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)))
num
)

;; Day 9 - Optional Pt. II
(define-read-only (is-some-example (num (optional uint))) 
    (is-some num)
)

(define-read-only (is-none-example (num (optional uint)))
    (is-none num)
)

(define-read-only (params-optional-and (num (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)))
    (and
        (is-some num)
        (is-some string)
        (is-some boolean)    
    )
)   

;; Day 10 - Intro to Variables and Constants
(define-constant fav-num u10)
(define-constant fav-string "Hi")
(define-data-var fav-num-var uint u11)
(define-data-var fav-name-string-var (string-ascii 48) " Gary Riger")

(define-read-only (show-constant)  
    fav-string
)
(define-read-only (show-constant-double)  
    (* fav-num u2)
)
(define-read-only (show-fav-num-var) 
    (var-get fav-num-var)
)   
(define-read-only (show-var-double) 
    (* u2 (var-get fav-num-var))
)
(define-read-only (say-hi) 
    (concat fav-string (var-get fav-name-string-var))
)

;; Day 11 - Public Functions & Resources
(define-read-only (response-example)
(ok u10)
) 

(define-public (change-name (new-name (string-ascii 24)))
   (ok  (var-set fav-name-string-var new-name) )
)

(define-public (change-fav-num (new-num uint))
    (ok (var-set fav-num-var new-num))
)

