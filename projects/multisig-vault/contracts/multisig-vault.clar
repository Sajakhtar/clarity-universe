
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
(define-data-var members (list 100 principal) (list))

(define-data-var votes-required uint u0)

;; The votes themselves will be stored in a map that uses a tuple key with two values: the principal of the member issuing the vote and the principal being voted for.
(define-map votes {member: principal, recipient: principal} {decision: bool})

;; functions
;;

(define-public (start (new-members (list 100 principal)) (new-votes-required uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-eq (len (var-get members)) u0) err-already-locked)
    (asserts! (>= (len new-members) new-votes-required) err-more-votes-than-members-required)

    (var-set members new-members)
    (var-set votes-required new-votes-required)

    (ok true)
  )
)

(define-public (vote (recipient principal) (decision bool))
  (begin
    (asserts! (is-some (index-of (var-get members) tx-sender)) err-not-a-member)
    (ok (map-set votes {member: tx-sender, recipient: recipient} {decision: decision}))
  )
)

(define-read-only (get-vote (member principal) (recipient principal))
  ;; If a member never voted for a specific principal before, we will default to a negative vote of false
  (default-to false (get decision (map-get? votes {member: member, recipient: recipient})))
)

(define-private (tally (member principal) (accumulator uint))
  (if (get-vote member tx-sender) (+ accumulator u1) accumulator)
)

(define-read-only (tally-votes)
  (fold tally (var-get members) u0)
)

(define-public (withdraw )
  (let
    (
      (recipient tx-sender)
      (total-votes (tally-votes))
    )
    (asserts! (>= total-votes (var-get votes-required)) err-votes-required-not-met)
    (try! (as-contract (stx-transfer? (stx-get-balance tx-sender) tx-sender recipient)))
    (ok total-votes)
  )
)

(define-public (deposit (amount uint))
  (stx-transfer? amount tx-sender (as-contract tx-sender))
)
