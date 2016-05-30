(in-package #:tgf)


(define-namespace tag symbol)

(defun find-tag (tag-name)
  "Return the tag name by tag-name"
  (symbol-tag tag-name))

;;; TODO: Find a better name
(defvar *tag-ledger* (make-hash-table)
  "A map from a tag to a set of generic functions.")

(defclass tagged-generic-function (standard-generic-function)
  ((tags :initform (make-hash-set)
         :accessor tags
         :documentation "A collection of tags belonging to the generic function."))
  (:metaclass c2mop:funcallable-standard-class)
  (:documentation "A generic function that can be tagged."))

(defun add-tag-gf (generic-function tag)
  "Add TAG to GENERIC-FUNCTION"
  (hs-insert (tags generic-function)
             generic-function)
  (setf (gethash tag *tag-ledger*)
        (hs-insert (gethash tag *tag-ledger* (make-hash-set))
                   generic-function)))

(defun remove-tag-gf (generic-function tag)
  "Remove TAG to GENERIC-FUNCTION"
  (hs-remove (tags generic-function)
             generic-function)
  (setf (gethash tag *tag-ledger*)
        (hs-remove (gethash tag *tag-ledger* (make-hash-set))
                   generic-function))

  (when-let (tag-set (gethash tag *tag-ledger*))
    (hs-emptyp tag-set)
    (remhash tag *tag-ledger*)))


;; Interface

(defun print-symbol (symbol stream)
  "Print SYMBOL to STREAM."
  (let* ((package-name (package-name (symbol-package symbol)))
         (pretty-package-name (if (string-equal "KEYWORD" package-name)
                                  ""
                                  package-name)))
    (format stream "~A:~A~%" pretty-package-name symbol)))
;; TODO: Rename tags to protocols
(defun print-tags (&optional (stream t))
  "Print all tags/protocols to STREAM."
  (maphash #'(lambda (key value)
               (declare (ignore value))
               (print-symbol key stream))
           *tag-ledger*))

(defun list-functions (protocol)
  (let ((result))
    (dohashset (gf (gethash protocol *tag-ledger*) result)
      (push gf result))))
