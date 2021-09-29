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
