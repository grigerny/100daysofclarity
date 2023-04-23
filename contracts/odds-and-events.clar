;; Day 92

;; Odds & Evens
;; Contract (A 2 player betting game)

;; Game 
;; @desc - We want people to be able to bet whether future block is going to be odds or events
;; @params - We have people, we have bets, we have a future block, we have a game, we have number of bets, number of players, winner
;; Two players bet the same amount that a future block will be odd or even
;; Player can have no more than 3 active bets at a time
;; Bets can only be made in factors of 5 & less than 50
;; Contract to charge 2 STXs to create a bet. 
;; Charge 2 STXs to join bet
;; Charge 1 STXs to cancel a bet
;; All or nothing for winner and loser

;; PLAN FOR SMART CONTRACT

;; We need a map that keeps track of bets
    ;; Player A
    ;; Player B
    ;; Agree on Amount
    ;; Agree on Block
    ;; Accepted Bet

    ;; Bet 
        ;; Create a Bet -> A bet needs to have principal A (Begins Game), Principal B (optional), Bet Amount, Bet Height
        ;; Cancel Bet -> Manual or auto-expire? 
        ;; Match Bet -> Principal B spots Bet A and fills in the second slot. Bet is now locked until reveal height
        ;; Reveal Bet -> Once reveal-height is reached either player can call to reveal

;;;;;;;;;;;;;;;;;;;;;;
;; Cons, vars, Maps ;;
;;;;;;;;;;;;;;;;;;;;;;

;; We need a minimum height for the block height (what is the minimum this bet can be in the future)
(define-constant min-future-height1 u10)

;; We need a minimum height for the block height 
(define-constant max-future-height u1008)

;; Max active bets (again)
(define-constant max-active-bets u3)

;; Max bet amount
(define-constant max-bet-amount u51)

;; Min bet amount
(define-constant min-bet-amount u5)

;; Create Bet Fee
(define-constant create-match-fee u2000000)

;; Cancel Bet
(define-constant cancel-fee u1000000)

;; We need a map that keeps track of status of a bet

(define-map bets uint { 
    opens-bet: principal,
    matches-bet: (optional principal),
    amount-bet: uint,
    high-bet: uint,
    winner: (optional principal)
     })

;; We need a map that keeps track of number of active bets per user
(define-map user-bets principal {open-bets: (list 100 uint), active-bets: (list 3 uint)})


;; We need a variable that lists all available bets (not yet active)
(define-data-var open-bets (list 100 uint) (list ))

;; We need a variable that keeps track of active bets
(define-data-var active-bets (list 100 uint) (list ))


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read Only Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Public Functions
    ;; Betting Functions ;;
        ;; Get all Open Bets

(define-read-only (get-open-bets) 
    (var-get open-bets)
)
        ;; Get all Acive Bets
(define-read-only (get-active-bets) 
    (var-get active-bets)
)
        ;; Get a specific Bet
(define-read-only (get-bet (bet-id uint)) 
    (map-get? bets bet-id)
)

        ;; Get User Bets
(define-read-only (get-user-bets (user principal))
    (map-get? user-bets user)
)

;;;;;;;;;;;;;;;;;;;;;
;;; Bet Function ;;;; 
;;;;;;;;;;;;;;;;;;;;;

;; Open/Create Bet
;; @desc - Public Function for creating an initial bet. Public function for cancelling a bet. Who is the Principal/tx-sender?
;; @param - Amount (uint), amount of bet / bet size - Height (uint) which is the block we are betting on.
(define-public (create-bet (amount uint) (height uint))
    (let 
    (
        (test true)
        (current-user-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets tx-sender)))
        (current-active-user-bets (get active-bets current-user-bets)  )
    )

    ;; Assert that amount that is less than to 50 STX

    ;; Assert that amount is factor of 5 (mod 5 =0)

   ;; Assert that height is higher than (+ min-future-height blockheight) & lower than (max-future-height + blockheight)

   ;; Assert that length of current-active-users-bets is less than 4

   ;; Charge the create/match fee

   ;; Send the STX to Escrow or Smart Contract

   ;; Update Map and Data Structure
    ;; Map Set current-user-bets
    ;; Map-set update bets and open-bets

         (ok test)
)
)

;; Match/Join Bat
;; @desc - public function for joining/matching an open bet
;; @param - do we need any? 
(define-public (match-bet (bet uint))
    (let 
        (
        (current-bet (unwrap! (map-get? bets bet) (err "err-bet-doesnt-exist")))
        (current-user-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets tx-sender)))
        ) 
       (ok current-user-bets)
    )
)