;; consumer-nft
;; SIP009 compliant NFT contract for Consumers to mint their data profile NFT

(impl-trait .sip009-nft-trait.sip009-nft-trait)

;; implementating trait when deploying to mainnet refernece the actual SIP009 trait contract on mainnet:
;; (impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; To Do
;; Consumer can mint one profile NFT per address / web2 account
;; Consumer can update profile meta data (offchain e.g. IPFS, Airweave)
;; private function - set meta data URI
;; private functio - update data meta URI
;; Mint fee covered by Trubit?

;; constants
;;
(define-constant contract-owner tx-sender)
(define-constant err-contract-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
;; error for already has a profile NFT


;; data maps and vars
;;
(define-non-fungible-token saj-nft uint)
(define-data-var last-token-id uint u0)


;; private functions
;;

;; public functions
;;
(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (ok none)
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? saj-nft token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
	(begin
		(asserts! (is-eq tx-sender sender) err-not-token-owner)
		(nft-transfer? saj-nft token-id sender recipient)
	)
)

(define-public (mint (recipient principal))
  (let
    ((token-id (+ (var-get last-token-id) u1)))
    (asserts! (is-eq tx-sender contract-owner) err-contract-owner-only)
    (try! (nft-mint? saj-nft token-id recipient))
    (var-set last-token-id token-id)
    (ok token-id)
  )
)
