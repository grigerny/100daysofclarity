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

;; Day 48 - Map revisted
(define-constant test-list-principals (list 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC))
(define-constant test-list-tuple (list {user: "Alice", balance: u10} {user: "Bob", balance: u11} {user: "Carl", balance: u12}))
(define-public (test-send-stx-multiple) 
    (ok (map send-stx-multiple test-list-principals))
)

(define-read-only (test-get-users) 
    (map get-user test-list-tuple)
)

(define-read-only (test-get-balance) 
    (map get-balance test-list-tuple)
)

(define-private (send-stx-multiple (item principal))
    (stx-transfer? u100000000 tx-sender item)
)

(define-private (get-user (item {user: (string-ascii 24), balance: uint}))
(get user item)
)

(define-private (get-balance (item {user: (string-ascii 24), balance: uint}))
(get balance item)
)

;; Day 49 - Fold
(define-constant test-list-ones (list u1 u1 u1 u1 u1))
(define-constant test-list-two (list u1 u2 u3 u4 u5))
(define-constant test-alphabet (list "g" "a" "r" "y"))

(define-read-only (fold-add-start-zero) 
    (fold + test-list-ones u0)
)

(define-read-only (fold-add-start-ten) 
    (fold + test-list-ones u10)
)
(define-read-only (fold-multiple-one) 
    (fold * test-list-two u1)
)

(define-read-only (fold-multiple-two) 
    (fold * test-list-two u2)
)

(define-read-only (fold-characters) 
    (fold concat-string test-alphabet "Hey ")
)

(define-private (concat-string (a (string-ascii 10)) (b (string-ascii 10)))
    (unwrap-panic (as-max-len? (concat b a) u10))
)

;; Day 50 - (Contract-call? 
(define-read-only (call-basics-i-multiply) 
    (contract-call? .clarity-basics-i multiply )
)

(define-read-only (call-basics-i-hello-world) 
    (contract-call? .clarity-basics-i say-hello-world )    
)

(define-public (call-basics-ii-hello-world (name (string-ascii 48))) 
    (contract-call? .clarity-basics-ii set-and-say-hello name)
)

(define-public (call-basics-iii-set-second-map (new-username (string-ascii 24)) (new-balance uint))
    (begin
       (try!  (contract-call? .clarity-basics-ii set-and-say-hello new-username))
              (contract-call? .clarity-basics-iii set-second-map new-username new-balance none) 
    )  
    
)