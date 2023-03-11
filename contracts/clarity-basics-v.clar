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