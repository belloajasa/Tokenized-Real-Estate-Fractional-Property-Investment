;; Property Maintenance Contract
;; Coordinates property maintenance and expense tracking

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_MAINTENANCE_NOT_FOUND (err u401))
(define-constant ERR_INSUFFICIENT_FUNDS (err u402))

;; Maintenance request structure
(define-map maintenance-requests
  { property-id: uint, request-id: uint }
  {
    description: (string-ascii 256),
    estimated-cost: uint,
    actual-cost: (optional uint),
    status: (string-ascii 20),
    requested-by: principal,
    approved-by: (optional principal),
    completed-at: (optional uint),
    created-at: uint
  }
)

(define-map maintenance-counter { property-id: uint } uint)

;; Maintenance fund tracking
(define-map maintenance-funds
  { property-id: uint }
  { total-fund: uint, total-spent: uint, reserved: uint }
)

;; Submit maintenance request
(define-public (submit-maintenance-request (property-id uint) (description (string-ascii 256)) (estimated-cost uint))
  (let ((request-id (+ (default-to u0 (map-get? maintenance-counter { property-id: property-id })) u1)))
    (map-set maintenance-requests
      { property-id: property-id, request-id: request-id }
      {
        description: description,
        estimated-cost: estimated-cost,
        actual-cost: none,
        status: "pending",
        requested-by: tx-sender,
        approved-by: none,
        completed-at: none,
        created-at: block-height
      }
    )
    (map-set maintenance-counter { property-id: property-id } request-id)
    (ok request-id)
  )
)

;; Approve maintenance request
(define-public (approve-maintenance (property-id uint) (request-id uint))
  (let ((request (unwrap! (map-get? maintenance-requests { property-id: property-id, request-id: request-id }) ERR_MAINTENANCE_NOT_FOUND)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set maintenance-requests
      { property-id: property-id, request-id: request-id }
      (merge request {
        status: "approved",
        approved-by: (some tx-sender)
      })
    )
    (ok true)
  )
)

;; Complete maintenance and record actual cost
(define-public (complete-maintenance (property-id uint) (request-id uint) (actual-cost uint))
  (let (
    (request (unwrap! (map-get? maintenance-requests { property-id: property-id, request-id: request-id }) ERR_MAINTENANCE_NOT_FOUND))
    (fund-data (default-to { total-fund: u0, total-spent: u0, reserved: u0 }
               (map-get? maintenance-funds { property-id: property-id })))
  )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (>= (- (get total-fund fund-data) (get total-spent fund-data)) actual-cost) ERR_INSUFFICIENT_FUNDS)

    ;; Update request
    (map-set maintenance-requests
      { property-id: property-id, request-id: request-id }
      (merge request {
        actual-cost: (some actual-cost),
        status: "completed",
        completed-at: (some block-height)
      })
    )

    ;; Update fund tracking
    (map-set maintenance-funds
      { property-id: property-id }
      (merge fund-data {
        total-spent: (+ (get total-spent fund-data) actual-cost)
      })
    )

    (ok true)
  )
)

;; Add funds to maintenance pool
(define-public (add-maintenance-funds (property-id uint) (amount uint))
  (let ((fund-data (default-to { total-fund: u0, total-spent: u0, reserved: u0 }
                   (map-get? maintenance-funds { property-id: property-id }))))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set maintenance-funds
      { property-id: property-id }
      (merge fund-data {
        total-fund: (+ (get total-fund fund-data) amount)
      })
    )
    (ok true)
  )
)

;; Get maintenance request details
(define-read-only (get-maintenance-request (property-id uint) (request-id uint))
  (map-get? maintenance-requests { property-id: property-id, request-id: request-id })
)

;; Get maintenance fund status
(define-read-only (get-maintenance-funds (property-id uint))
  (map-get? maintenance-funds { property-id: property-id })
)
