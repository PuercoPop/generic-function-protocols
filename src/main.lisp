(in-package #:gfp)


(define-namespace protocol symbol)

(defun find-protocol (protocol-name)
  "Return the protocol named by PROTOCOL-NAME."
  (symbol-protocol protocol-name))

;;; TODO: Find a better name
(defvar *protocol-ledger* (make-hash-table)
  "A map from a protocol to a set of generic functions.")

(defclass generic-function-with-protocol (standard-generic-function)
  ((protocols :initform (make-hash-set)
         :accessor protocols
         :documentation "A collection of protocols the generic function belongs to."))
  (:metaclass c2mop:funcallable-standard-class)
  (:documentation "A generic function that can be marked belonging to a protocol."))

(defun add-protocol-gf (generic-function protocol)
  "Mark GENERIC-FUNCTION as part of PROTOCOL"
  (hs-insert (protocols generic-function)
             generic-function)
  (setf (gethash protocol *protocol-ledger*)
        (hs-insert (gethash protocol *protocol-ledger* (make-hash-set))
                   generic-function)))

(defun remove-tag-gf (generic-function protocol)
  "Remove PROTOCOL from GENERIC-FUNCTION"
  (hs-remove (protocols generic-function)
             generic-function)
  (setf (gethash protocol *protocol-ledger*)
        (hs-remove (gethash protocol *protocol-ledger* (make-hash-set))
                   generic-function))

  (when-let (protocol-set (gethash protocol *protocol-ledger*))
    (hs-emptyp protocol-set)
    (remhash protocol *protocol-ledger*)))


;; Interface

(defun print-symbol (symbol stream)
  "Print SYMBOL to STREAM."
  (let* ((package-name (package-name (symbol-package symbol)))
         (pretty-package-name (if (string-equal "KEYWORD" package-name)
                                  ""
                                  package-name)))
    (format stream "~A:~A~%" pretty-package-name symbol)))

(defun print-protocols (&optional (stream t))
  "Print all protocols to STREAM."
  (maphash #'(lambda (key value)
               (declare (ignore value))
               (print-symbol key stream))
           *protocol-ledger*))

(defun list-functions (protocol)
  (let ((result))
    (dohashset (gf (gethash protocol *protocol-ledger*) result)
      (push gf result))))
