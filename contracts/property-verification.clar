;; Property Verification Contract
;; Validates and manages real estate property listings

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_PROPERTY_EXISTS (err u101))
(define-constant ERR_PROPERTY_NOT_FOUND (err u102))
(define-constant ERR_INVALID_VERIFICATION (err u103))

;; Property data structure
(define-map properties
  { property-id: uint }
  {
    owner: principal,
    address: (string-ascii 256),
    value: uint,
    verified: bool,
    verifier: (optional principal),
    verification-date: (optional uint)
  }
)

(define-data-var next-property-id uint u1)

;; Authorized verifiers
(define-map authorized-verifiers principal bool)

;; Add a new property for verification
(define-public (add-property (address (string-ascii 256)) (value uint))
  (let ((property-id (var-get next-property-id)))
    (asserts! (is-none (map-get? properties { property-id: property-id })) ERR_PROPERTY_EXISTS)
    (map-set properties
      { property-id: property-id }
      {
        owner: tx-sender,
        address: address,
        value: value,
        verified: false,
        verifier: none,
        verification-date: none
      }
    )
    (var-set next-property-id (+ property-id u1))
    (ok property-id)
  )
)

;; Authorize a verifier
(define-public (authorize-verifier (verifier principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set authorized-verifiers verifier true)
    (ok true)
  )
)

;; Verify a property
(define-public (verify-property (property-id uint))
  (let ((property (unwrap! (map-get? properties { property-id: property-id }) ERR_PROPERTY_NOT_FOUND)))
    (asserts! (default-to false (map-get? authorized-verifiers tx-sender)) ERR_UNAUTHORIZED)
    (map-set properties
      { property-id: property-id }
      (merge property {
        verified: true,
        verifier: (some tx-sender),
        verification-date: (some block-height)
      })
    )
    (ok true)
  )
)

;; Get property details
(define-read-only (get-property (property-id uint))
  (map-get? properties { property-id: property-id })
)

;; Check if property is verified
(define-read-only (is-property-verified (property-id uint))
  (match (map-get? properties { property-id: property-id })
    property (get verified property)
    false
  )
)
