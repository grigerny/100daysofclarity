
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

(define-map track { artist: principal, album: (string-ascii 24), track-id: uint } {
    title: (string-ascii 24),
    duration: uint,
    featured: (optional principal)
})


;; Maps that keep track of a single map

(define-map album { artist: principal, album-id: uint } {
    tracks: (list 10 uint),
    published: uint
    
})

;; Maps that keep track of a discography
(define-map discography  principal (list 10 uint))


;;;; Read Functions ;;;;

;;;; Write Functions ;;;;

;;;; Admin Functions ;;;;