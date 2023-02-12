
;; Artist Discography
;; Contracts that models an artist discography (giscography -> albums -> tracks)
;; Written by Setzeus / StrataLabs

;; Discography  
;; An artist discography is a list of albums
;; An admin can start a discography

;; Album
;; An Album is a list of tracks
;; The artist or an admin can start an album & can add/remove tracks.

;;Track
;;Track is made up of a name, a duration (in seconds), & a possible feature (otional feature)
;;The Artist or an admin can start a track & can add/remove tracks



;;;; Cons, Vars & Maps ;;;;;
;; Artist , Track, album ID or name

;; Maps that keep track of a single track

(define-map track { artist: principal, album-id: uint, track-id: uint } {
    title: (string-ascii 24),
    duration: uint,
    featured: (optional principal)
})


;; Maps that keep track of a single album

(define-map album { artist: principal, album-id: uint } {
    tracks: (list 10 uint),
    published: uint,
    height-published: (optional principal)
    
})

;; Maps that keep track of a discography
(define-map discography  principal (list 10 uint))


;;;; Read Functions ;;;;

;; get track data

(define-read-only (get-track-data (artist principal) (album-id uint) (track-id uint))
    (map-get? track {artist: artist, album-id: album-id, track-id: track-id})
)

;; get featured artist

(define-read-only (get-featured-artist (artist principal) (album-id uint) (track-id uint))
    (get featured (map-get? track {artist: artist, album-id: album-id, track-id: track-id}))
)
;; get album data

(define-read-only (get-album-data (artist principal) (album-id uint))
    (map-get? album { artist: artist, album-id: album-id })
)

;; get published
(define-read-only (get-album-published-height (artist principal) (album-id uint))
    (get height-published (map-get? album { artist: artist, album-id: album-id }))
)

;; get discography

(define-read-only (get-descogrophy (artist principal)) 
    (map-get? discography artist)
)

;; get albums published

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Write Functions ;;;;

;; Add a track

(define-public (add-a-track (artist principal) (title (string-ascii 24)) (duration uint) (featured (optional principal)) (album-id uint))
    (let 
        (
            (test u0)
        )
    ;; Assert that tx-sender is either artist or admin

    ;; Assert that album exists in Discography
    
    ;; Assert that duration is less than 600 seconds (10 mins)

    ;; Map-set new track

    ;; Map-set append track to album

        (ok test)
    )
)

;; @desc - function that allows a user or admin to add a track. 
;; param - title (string-ascii 24), duration (uint, featured-artist (optional principal), )


;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Admin Functions ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add Admin
;; Remove Admin

;; Maps that keep track of a single track

;; (define-map track { artist: principal, album-id: uint, track-id: uint } {
;; title: (string-ascii 24),
;; duration: uint,
;; featured: (optional principal)
;; })


;; Maps that keep track of a single album

;; (define-map album { artist: principal, album-id: uint } {
;;  tracks: (list 10 uint),
;;  published: uint,
;;  height-published: (optional principal)   
;; })

;; Maps that keep track of a discography
;; (define-map discography  principal (list 10 uint))