;; saj-coin
;; SIP010 compliant FT contract

(impl-trait .sip010-ft-trait.sip010-ft-trait)

;; implementating trait when deploying to mainnet refernece the actual SIP010 trait contract on mainnet:
;; (impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; constants
;;
(define-constant contract-owner tx-sender)
(define-constant err-contract-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; data maps and vars
;;
(define-fungible-token saj-coin) ;; no supply cap

;; private functions
;;

;; public functions
;;
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (try! (ft-transfer? saj-coin amount sender recipient) )
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

(define-read-only (get-name)
  (ok "Saj Coin")
)

(define-read-only (get-symbol)
  (ok "SAJ")
)

(define-read-only (get-decimals)
  (ok u6)
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance saj-coin who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply saj-coin))
)

(define-read-only (get-token-uri)
  (ok none)
)

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-contract-owner-only)
    (ft-mint? saj-coin amount recipient)
  )
)
