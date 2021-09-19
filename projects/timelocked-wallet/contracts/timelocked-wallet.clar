
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

;; Data
(define-data-var beneficiary (optional principal) none)
(define-data-var unlock-heigth uint u0)

;; data maps and vars
;;

;; private functions
;;

;; public functions
;;
