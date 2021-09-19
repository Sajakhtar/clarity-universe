
;; multisig-vault
;; <add a description here>

;; constants
;;

;; Owner
(define-constant contract-owner tx-sender)

;; Errors
(define-constant err-owner-only (err u100)) ;; Someone other than the owner is trying to initialise
(define-constant err-already-locked (err u101)) ;; The vault is already locked
(define-constant err-more-votes-than-members-required (err u102)) ;; The initialising call specifies an amount of votes required that is larger the number of members
(define-constant err-not-a-member (err u103)) ;; The voting process itself will only fail if a non-member tries to vote
(define-constant err-votes-required-not-met (err u104)) ;; withdrawal function will only succeed if the voting threshold has been reached.


;; data maps and vars
;;

;; The members will be stored in a list with a given maximum length.
(define-data-var member (list 100 principal) (list))

(define-data-var votes-required uint u0)

;; The votes themselves will be stored in a map that uses a tuple key with two values: the principal of the member issuing the vote and the principal being voted for.
(define-map votes {member: principal, recipient: principal} {decision: bool})


;; private functions
;;

;; public functions
;;
