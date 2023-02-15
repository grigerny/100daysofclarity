
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

;;Admin list of principals
(define-data-var admins (list 10 principal) (list tx-sender))

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

(define-public (add-a-track (artist (principal)) (title (string-ascii 24)) (duration uint) (featured (optional principal)) (album-id uint))
    (let 
        (
            (current-discography (unwrap! (map-get? discography artist)) (err u0))
            (current-album (unwrap! (index-of current-discography album-id)) (err u2))
            (current-album-data (unwrap! (map-get? album {artist: artist, album-id: album-id})) (err u3))
            (current-album-tracks (get tracks current-album-data))
            (current-album-track-id (len current-album-tracks))
            (next-album-track-id) (+ u1 current-album-tack-id)
        )

            ;; Check whether discography exists /if discography is-some  

                ;; Discography exists

                    ;; Map-set new album

                    ;; Append new album to discgraphy


                ;; Discography does not exist

                    ;; Map-set new discography

                    ;; map-set new album


                ;; Append new album to discography 
            ;;this is where my body goes
    )
)

;; Add a album

(define-public (add-album-or-create-dicsography-and-add-album (artist (optional principal)) (album-title (string-ascii 24)))
(let 
    (
        (test u8)

    )
            ;;this is where my local variables go 

        

            ;; Check whether discography exists /if discography is-some  

                ;; Discography exists

                    ;; Map-set album map by appending album

                    ;; Append new album to discgraphy


                ;; Discography does not exist

                    ;; Map-set new discography

                    ;; map-set new album


                ;; Append new album to discography 
            ;;this is where my body goes
           
    ;; Assert that tx-sender is either artist or admin

    (asserts! (or (is-eq tx-sender artist) (is-some (index-of (var-get admins) tx-sender))) (err u1))

    ;; Assert that album exists in Discography

    (asserts! (is-some (index-of current-discography album-id)) (err u2))
    
    ;; Assert that duration is less than 600 seconds (10 mins)
    (asserts! (< duration 600) (err u3))

    ;; Map-set new track
    (map-set track {artist: artist, album-id: album-id, track-id: u0} {
        title: title, 
        duration: duration,
        featured: featured
    })

    ;; Map-set album map by appending track to album
    (ok (map-set album {artist: artist, album-id: album-id} 
        (merge 
             current-album-data
             {tracks: (unwrap! (as-max-len? (append current-album-tracks next-album-track-id) u10) u4)}
        )
    ))
    )
)
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Admin Functions ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add Admin
;; @desc - function that existing admin can add another admin 

(define-public (add-domain (new-admin principal))
(let 
    (
        (test u0)
    )

        (ok test)
    )

)
;; Remove Admin
;; @desc - function that removes an existing admin
;; @param - removed admin (principal)

(define-public (remove-admin (remove-admin principal)) 
    (let
        (
         (test u8)
        )

        ;; tx-sender is an existing admin
        ;; Assert that removed-admin IS an existing admin
        ;; 
         (ok test)
)
)

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