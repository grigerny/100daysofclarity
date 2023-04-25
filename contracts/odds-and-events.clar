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
    opens-bet-guess: bool,
    matches-bet: (optional principal),
    amount-bet: uint,
    height-bet: uint,
    winner: (optional principal)
     })

;; We need a map that keeps track of number of active bets per user
(define-map user-bets principal {open-bets: (list 100 uint), active-bets: (list 3 uint)})


;; Var for keeping track of the bet index
(define-data-var bet-index uint u0)

;; We need a variable that lists all available bets (not yet active)
(define-data-var open-bets (list 100 uint) (list ))

;; We need a variable that keeps track of active bets
(define-data-var active-bets (list 100 uint) (list ))

;; Helper var for filtering out uints
(define-data-var helper-uint uint u0)

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
;; @param - Amount (uint), amount of bet / bet size - Height (uint) which is the block we are betting on, - Guess (bool), true = even, false = odd
(define-public (create-bet (amount uint) (height uint) (guess bool))
    (let 
    (
        (test true)
        (current-bet-id (var-get bet-index))
        (next-bet-id (var-get bet-index))
        (current-user-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets tx-sender)))
        (current-active-user-bets (get active-bets current-user-bets)  )
    )

    ;; Assert that amount that is less than to 50 STX
    (asserts! (< amount u50000000) (err "err-bet-amount-too-high"))

    ;; Assert that amount is factor of 5 (mod 5 =0)
    (asserts! (is-eq (mod amount u5) u0) (err "err-bet-amount-not-factor-of-5"))

   ;; Assert that height is higher than (+ min-future-height blockheight) & lower than (max-future-height + blockheight)
    (asserts! (and (>= height (+ min-future-height1 block-height)) (<= height (+ max-future-height block-height))) (err "err-bet-height"))

   ;; Charge the create/match fee
   (unwrap! (stx-transfer? create-match-fee tx-sender (as-contract tx-sender)) (err "err-stx-transfer"))

   ;; Send the STX to Escrow or Smart Contract
    (unwrap! (stx-transfer? amount tx-sender (as-contract tx-sender)) (err "err-tx-transfer"))

    ;; Map-set current-user-bets
    (map-set user-bets tx-sender (merge
        current-user-bets
        {open-bets: (unwrap! (as-max-len? (append current-active-user-bets current-bet-id) u100) (err "err-user-bets-list-is-too-long"))}

    ))
    ;; var-set open bets by appending current-bet-id
    (var-set open-bets (unwrap! (as-max-len? (append (var-get open-bets) current-bet-id) u100) (err "err-open-bets-list-too-long")))
    
    ;; Map-set bets
    (map-set bets current-bet-id {
        opens-bet: tx-sender,
        opens-bet-guess: guess,
        matches-bet: none, 
        amount-bet: amount, 
        height-bet: height, 
        winner: none
    })

    ;; var-set current-bet-id next-idnex
    (ok (var-set bet-index (+ next-bet-id u1)))
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
        (current-user-open-bets (get open-bets current-user-bets))
        (current-user-active-bets (get active-bets current-user-bets))
        (current-bet-height-bet (get height-bet current-bet))
        (current-contract-wide-open-bets (var-get open-bets))
        (current-contract-wide-active-bets (var-get active-bets))

        ) 

        ;; THIS IS WHEN SOMEONE IS JOINING AN EXISTING BET: 

        ;; Assert that the block-height is less than or equal to the current-bet-height
        (asserts! (<= block-height current-bet-height-bet) (err "err-bet-height")) 


        ;; Assert that (just a name of a func -> ) current-user-active-bets is less than or equal to 3
        (asserts! (< (len current-user-active-bets) u3) (err "err-user-active-bets-too-many"))

        ;; Transfer current-bet-amount in STX (as collatoral) and match fee set
        (unwrap! (stx-transfer? (+ (get amount-bet current-bet) create-match-fee) tx-sender (as-contract tx-sender)) (err "err-stx-transfer"))

        ;; Map-Set current-bet by merging current-bet with matches-bet
        (map-set bets bet (merge current-bet
        {matches-bet: (some tx-sender)}
        ))

        ;; Map-Set user-bets by appending bet to current-active-bets list & by filtering out bet with filter out uint
        (map-set user-bets tx-sender {
            open-bets: (filter filter-out-uint current-user-open-bets),
            active-bets: (unwrap! (as-max-len? (append current-user-active-bets bet) u3) (err "Err user bets list too long"))
        })

        ;; var-set open-bets by filtering out bet from current-contract-wide-open-bets using filter-out-uint
        (var-set open-bets (filter filter-out-uint current-contract-wide-open-bets))

        ;; Var-set active-bets by appending bet to current-contract-wide-active-bets
       (ok (var-set active-bets (unwrap! (as-max-len? (append current-contract-wide-active-bets bet) u100) (err "err-active-bets-list-too-long"))))

    )
)

(define-private (filter-out-uint (bet uint))
    (not (is-eq bet (var-get helper-uint)))
)

;;Reveal Bet
;;@desc - Public function for either principal a or b to reveal & end an active bet
;;@param - Bet (uint), the bet that we're ending
(define-public (reveal-bet (bet uint))
    (let 
        (   
        (current-bet (unwrap! (map-get? bets bet) (err "err-bet-doesnt-exist")))
        (current-bet-height (get height-bet current-bet))
        (current-bet-opener (get opens-bet current-bet))
        (current-bet-opener-guess (get opens-bet-guess current-bet))
        (current-bet-matcher (unwrap! (get matches-bet current-bet) (err "no-bet-matcher")))
        (current-user-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets tx-sender)))
        (current-user-open-bets (get open-bets current-user-bets))
        (current-user-active-bets (get active-bets current-user-bets))
        (current-matcher-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets current-bet-matcher)))
        (current-matcher-open-bets (get open-bets current-matcher-bets))
        (current-matcher-active-bets (get active-bets current-matcher-bets))
        (current-bet-height-bet (get height-bet current-bet))
        (current-contract-wide-open-bets (var-get open-bets))
        (current-contract-wide-active-bets (var-get active-bets))
        (random-number-at-block (unwrap! (get-random-uint-at-block current-bet-height) (err "err-random-number-at-block")))
        )

        ;; Assert that bet is active by checking index-of current-contract-wide-open-bets
        (asserts! (is-some (index-of current-contract-wide-active-bets bet)) (err "err-bet-not-active"))

        ;; Assert that block-height is higher than current-bet-height
        (asserts! (> block-height current-bet-height) (err "err-bet-height"))

        ;; Check if random number at block mod 2 == 0 
            ;; if random number is even
                ;; Check if opener-guess is even
                ;; Send double amount to opener
                    ;; Map-set bet by merging current-bet with {winner: }

                ;; Send double amount to matcher
                    ;; Map-set bet by merging current-bet with {winner: }


            ;; if random number is odd
                ;; check if opener-guess is even
                ;; Send double amount to matcher
                ;; Send double amount to open
            (if (is-eq (mod random-number-at-block u2) u0)
            ;; if random is even

            ;; Random number is EVEN
            (if current-bet-opener-guess
                (begin 
                    (as-contract (unwrap! (stx-transfer? (* (get amount-bet current-bet) u2) tx-sender current-bet-opener) (err "err-stx-transfer")))
                )   

            ;; Map-set bet by merging current-bet with {winner: {come current-bet-opener}}
            (map-set bets bet (merge current-bet {winner: (some current-bet-opener)}))


            ;; if random is odd
            (begin 

            ;; Transfer double amount to matcher
                (unwrap! (stx-transfer? (* (get amount-bet current-bet) u2) tx-sender (some current-bet-matcher)) (err "err-stx-transfer"))

            ;; Map-set bet by merging current-bet with {winner: (some current-bet-matcher)}
                (map-set bets bet (merge current-bet {winner: (some current bet-matcher)}))
                )
                )

                  ;; Random number is ODD
            (if current-bet-opener-guess
                (begin 
                    (unwrap! (stx-transfer? (* (get amount-bet current-bet) u2) tx-sender current-bet-opener) (err "err-stx-transfer"))
                )   

            ;; Map-set bet by merging current-bet with {winner: {come current-bet-opener}}
            (map-set bets bet (merge current-bet {winner: (some current-bet-opener)}))


            ;; if random is odd
            (begin 

            ;; Transfer double amount to matcher
                (unwrap! (stx-transfer? (* (get amount-bet current-bet) u2) tx-sender (some current-bet-matcher)) (err "err-stx-transfer"))

            ;; Map-set bet by merging current-bet with {winner: (some current-bet-matcher)}
                (map-set bets bet (merge current-bet {winner: (some current bet-matcher)}))
                )
                )
            )

           ;; var-set helper uint
           (var-set helper-uint)

           ;; var-set active-bets by filtering out bet from active-bets
           (var-set active-bets (filter-out-uint current-contract-wide-active-bets))

           ;; Map-set user-bets for opener
           (map-set user-bets current-bet-opener {open-bets: (filter filter-out-uint current-user-open-bets), active-bets: current-user-active-bets})

           ;; Map-set user-bets for matcher
           (ok (map-set user-bets current-bet-matcher {open-bets: (filter filter-out-uint current-matcher-open-bets), active-bets: current-matcher-active-bets}))
    )
)

;; Day 97 & Day 99
;; Cancel Bet
;; @desc - Cancel an open bet
;; @param - but (uint), that we are cancelling

(define-public (cancel-bet (bet uint))
    (let 
        (
        (current-bet (unwrap! (map-get? bets bet) (err "err-bet-doesnt-exist")))
        (current-bet-opener (get opens-bet current-bet))
        (current-bet-amount (get amount-bet current-bet))
        (current-bet-matcher (get matches-bet current-bet))
        (current-user-bets (default-to {open-bets: (list ), active-bets: (list )} (map-get? user-bets tx-sender)))
        (current-user-open-bets (get open-bets current-user-bets))
        (current-contract-wide-open-bets (var-get open-bets))
        ) 

    ;; Assert that TX-Sender is current bet opener
    (asserts! (is-eq tx-sender current-bet-opener) (err "err-not-opener"))

    ;; Assert that current-bet matcher is none
    (asserts! (is-none current-bet-matcher) (err "err-bet-already-matched"))

    ;; Assert that current-contract-wide-active-bets is none
    (asserts! (is-none (index-of bet current-contract-wide-active-bets)) (err "err-bet-already-active"))

    ;; Assert that current contract-wide-open-bets is some
    (asserts! (is-some (index-of bet current-contract-wide-open-bets)) (err "err-bet-not-open"))

    ;; Assert that current-user-open-bets index of bet is some
    (asserts! (is-some (index-of bet current-user-open-bets) (err "err-bet-not-open"))

    ;; Transfer STX amount (amount - 1) from contract to user
    (as-contract (unwrap! (stx-transfer? (- current-bet-amount u1) (as-contract tx-sender) tx-sender) (err "err-transfer-failed"))))

    ;; Delete Map
    (map-delete bets bet)

    ;; var-set helper-uint
    (var-set helper-uint bet)

    ;; Map-set user-bets with filtered out open-bet
    (map-set user-bets tx-sender (merge current-user-bets {open-bets: (filter filter-out-uint current-user-open-bets)}))

    ;; Var-set  open-bets with filtered out open-bet
    (ok (var-set open-bets (filter filter-out-uint current-contract-wide-open-bets)))
    
    )
)

;;;;;;;;;;;;;;;;;;;;;
;; RANDOM FUNCTION ;;
;;;;;;;;;;;;;;;;;;;;;

 ;; Read the on-chain VRF and turn the lower 16 bytes into a uint
 (define-read-only (get-random-uint-at-block (stacksBlock uint)) 
    (let 
    (
        (vrf-lower-uint-opt (match (get-block-info? vrf-seed stacksBlock)
            vrf-seed (some (buff-to-uint-le (lower-16-le vrf-seed)))
            none))
    ) 
    vrf-lower-uint-opt
    (ok true)
    )
 )