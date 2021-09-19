
;; timelocked-wallet
;; <add a description here>

;; constants
;;

;; Owner
(define-constant contract-owner tx-sender)

;; Errors
(define-constant err-owner-only (err u100)) ;; Somebody other than the contract owner called lock
(define-constant err-already-locked (err u101)) ;; The contract owner tried to call lock more than once
(define-constant err-unlock-in-past (err u102)) ;; The passed unlock height is in the past
(define-constant err-no-value (err u103)) ;; The owner called lock with an initial deposit of zero (u0)
(define-constant err-beneficiary-only (err u104)) ;; Somebody other than the beneficiary called claim or lock
(define-constant err-unlock-height-not-reached (err u105)) ;; The beneficiary called claim but the unlock height has not yet been reached

;; data maps and vars
;;

;; Data
(define-data-var beneficiary (optional principal) none)
(define-data-var unlock-height uint u0)


;; private functions
;;

;; public functions
;;


;; lock
(define-public (lock (new-beneficiary principal) (unlock-at uint) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only) ;; Only the contract owner may call lock
    (asserts! (is-none (var-get beneficiary)) err-already-locked) ;; The wallet cannot be locked twice
    (asserts! (> unlock-at block-height) err-unlock-in-past) ;; The passed unlock height is in the future
    (asserts! (> amount u0) err-no-value) ;; The initial deposit should be larger than zero

    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set beneficiary (some new-beneficiary))
    (var-set unlock-height unlock-at)

    (ok true)
  )
)

;; bestow
(define-public (bestow (new-beneficiary principal))
  (begin
    (asserts! (is-eq (some tx-sender) (var-get beneficiary)) err-beneficiary-only) ;; checks if the tx-sender is the current beneficiary
    (var-set beneficiary (some new-beneficiary))
    (ok true)
  )
)

;; claim
(define-public (claim)
  (begin
    (asserts! (is-eq (some tx-sender) (var-get beneficiary)) err-beneficiary-only) ;; check if tx-sender is the beneficiary
    (asserts! (>= block-height (var-get unlock-height)) err-unlock-height-not-reached) ;; check the unlock height has been reached

    (as-contract (stx-transfer? (stx-get-balance tx-sender) tx-sender (unwrap-panic (var-get beneficiary)))) ;; tx-sender is contract
  )
)
