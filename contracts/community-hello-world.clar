;; community-hello-world 
;; contract that provides a simple community billboard readable by anoyone but only updateable the admin's permission

;;;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, & Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Constant that sets deplopyer principal as admin ;;
(define-constant admin tx-sender)

;; Variable that keeps track of the next user that'll introduce themselves / write to the billboards;;
(define-data-var next-user principal tx-sender)

;; Variable tuple that contains new member info ;;
(define-data-var billboard {new-user-principal: principal, new-user-name: (string-ascii 24)} {
    new-user-principal: tx-sender, 
    new-user-name: "" 
    }
)
;;;;;;;;;;;;;;;;;;;;;;;;)
;;   Read Functions s ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Get community Billboard

(define-read-only (get-billboard) 
    (var-get billboard))

(define-read-only (get-next-user) 
    (var-get next-user))



;;;;;;;;;;;;;;;;;;;;;;;;
;;  Write Functions s ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Update Billboard
;; @desc - function used by next-user to update the community billboard
;; @param - new-user-name: (string-ascii 24)

(define-public (update-billboard (updated-user-name (string-ascii 24))) 
    (begin 
;; Assert that tx-sender is not-user (approved by admin)
;; Assert that updated -user-name is not empty
;; Var-set billboard with new keys
        (ok true)
    )
)

;; Admin Set New User
;; @desc - function used by admin to set / give permission to next user

(define-public (admin-set-new-user) 
(begin 

    ;; Assert that tx-sender is admin
    ;; Assert that updated-user-principal is NOT  admin
    ;; Assert that updated-user-principal is NOT current next-user
    ;; Var-set next-user with updated-user-principal

(ok true) ))