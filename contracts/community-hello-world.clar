;; community-hello-world 
;; contract that provides a simple community billboard readable by anoyone but only updateable the admin's permission

;;;;;;;;;;;;;;;;;;;;;;;;
;; Cons, Vars, & Maps ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Constant that sets deplopyer as admin ;;
(define-constant admin tx-sender)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variable that keeps track of the next user ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-data-var next-user principal tx-sender)

;; Variable Billboard ;;
(define-data-var billboard {new-user-principal: principal, new-user-name: (string-ascii 24)} {
    new-user-principal: tx-sender, 
    new-user-name: "" 
    }
)
;;;;;;;;;;;;;;;;;;;;;;;;)
;;   Read Functions s ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;
;;  Write Functions s ;;
;;;;;;;;;;;;;;;;;;;;;;;;