
;; counter
;; Description: multiplayer counter contract

;; constants
;;

;; data maps and vars
;;

;; map to store the individual counter values
(define-map counters principal uint)


;; private functions
;;

;; public functions
;;

;;  read-only function that returns the counter value for a specified principal
(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)

;; count-up function that will increment the counter for the tx-sender
(define-public (count-up)
  (begin
    (ok (map-set counters tx-sender (+ (get-count tx-sender) u1)))
  )
)
