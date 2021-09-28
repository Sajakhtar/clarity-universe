;; saj-nft
;; SIP009 compliant NFT contract

(impl-trait .sip009-nft-trait.sip009-nft-trait)

;; implementating trait when deploying to mainnet refernece the actual SIP009 trait contract on mainnet:
;; (impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)


;; constants
;;
(define-constant contract-owner tx-sender)
(define-constant err-owner-only u100)
(define-constant err-not-token-owner u101)

;; data maps and vars
;;
(define-non-fungible-token saj-nft uint)
(define-data-var last-token-id uint u0)


;; private functions
;;

;; public functions
;;
