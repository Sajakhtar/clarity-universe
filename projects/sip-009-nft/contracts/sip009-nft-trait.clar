
;; sip009-nft-trait
;; https://book.clarity-lang.org/ch10-01-sip009-nft-standard.html#the-sip009-nft-trait
;; https://github.com/stacksgov/sips/blob/main/sips/sip-009/sip-009-nft-standard.md

(define-trait sip009-nft-trait
  (
    ;; Last token ID, limited to uint range
    (get-last-token-id () (response uint uint))

    ;; URI for metadata associated with the token
    (get-token-uri (uint) (response (optional (string-ascii 256)) uint))

    ;; Owner of a given token identifier
    (get-owner (uint) (response (optional principal) uint))

    ;; Transfer from the sender to a new principal
    (transfer (uint principal principal) (response bool uint))
  )
)
