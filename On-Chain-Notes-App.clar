;; On-Chain Notes App
;; Store short encrypted notes on-chain (encrypted off-chain, decrypted by creator)

;; Constants
(define-constant err-note-too-long (err u100))
(define-constant err-not-authorized (err u101))
(define-constant max-note-length u256) ;; Max encrypted note length in bytes

;; Data storage
(define-map notes principal (buff 256))

;; Public function: Create or update a note
(define-public (save-note (encrypted-note (buff 256)))
  (begin
    (asserts! (<= (len encrypted-note) max-note-length) err-note-too-long)
    (map-set notes tx-sender encrypted-note)
    (ok true)
  )
)

;; Read-only function: Retrieve your note
(define-read-only (get-my-note)
  (let ((note (map-get? notes tx-sender)))
    (match note stored
      (ok stored)
      err-not-authorized
    )
  )
)

