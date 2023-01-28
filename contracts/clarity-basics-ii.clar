
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

;; Day 12 - Tuples & Merging
(define-read-only (read-tuple-i) 
  {
        user-principal: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM,
        user-name: "John",
        user-balance: u10
    }
)

(define-public (write-tuple-i (new-user-principal principal) (new-user-name (string-ascii 24)) (new-user-balance uint))
 (ok
 {
        user-principal: new-user-principal,
        user-name: new-user-name,
        user-balance: new-user-balance
    }
 )
)
(define-data-var original {user-principal: principal, user-name: (string-ascii 24), user-balance: uint}
{
    user-principal: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM,
    user-name: "Gary",
    user-balance: u50
}
)

(define-read-only (read-original) 
    (var-get original)
)

(define-public (merge-principal (new-user-principal principal))
    (ok (merge 
        (var-get original)
        {user-principal: new-user-principal}
        )
    )   
)

(define-public (merge-user-name (new-user-name (string-ascii 24 ))) 
    (ok (merge 
        (var-get original) 
        {user-name: new-user-name}
    ))

)

(define-public (merge-all (new-user-principal principal) (new-user-name (string-ascii 24)) (new-user-balance uint))
(ok (merge
    (var-get original)
    {
        user-principal: new-user-principal,
        user-name: new-user-name,
        user-balance: new-user-balance
    }
    ))
)

;; Define 13 - Tx Sender & Is-Eq
(define-read-only (show-tx-sender) 
tx-sender
)

(define-constant admin 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-read-only (check-admin) 
(is-eq admin tx-sender)
)

;; Day 14 - Conditionals i (asserts)

(define-read-only (show-asserts (num uint)) 
( ok (asserts! (> num u2) (err u1)))
)

(define-constant error-too-large (err u10))
(define-constant error-too-small (err u2))
(define-constant error-not-auth (err u3))
(define-constant admin-one tx-sender)
(define-read-only (assert-admin) 
    ( ok (asserts! (is-eq tx-sender admin-one) error-not-auth))
)

;;Day 15 - Begin
;;Set and say hello
;;Counter by even

;; @desc - This function allows a user to provide a name, which, if different, changes a name variable & returns "hello new name"
;; param - new-name: (string-ascii 48)

(define-data-var hello-name (string-ascii 48) "Alice")
(define-public (set-and-say-hello (new-name (string-ascii 48)))
    (begin 
        ;;assert that name is not empty
        (asserts! (not (is-eq "" new-name)) (err u1))
        
        ;;assert that name is not equal to current name
        (asserts! (not (is-eq (var-get hello-name) new-name)) (err u2))

        ;;var-set new name
        (var-set hello-name new-name)

        ;;say hello new name
        (ok (concat "Hello  " (var-get hello-name)))
    )
)

(define-read-only (read-hello-name)
    (var-get hello-name)
) 

(define-data-var counter uint u0)
(define-read-only (read-counter) 
    (var-get counter)
)
;; @desc - This function allows a user to increase the counter by only an even amount. 
;; @param - We're going to call a variable add-num which is a uiint that user can submit (even only)

(define-public (increment-counter-even (add-num uint)) 
    (begin  
    ;;assert that add-num is even
       (asserts! (is-eq u0 (mod add-num u2)) (err u3))
    ;;increment & var-set counter
        (ok (var-set counter (+ (var-get counter) add-num)))    
    ;; add ok when it's a public funtion
    )
)