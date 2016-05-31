(in-package #:gfp)

(defun list-sans-element (list index-to-remove)
  "Return a new LIST with the element at INDEX-TO-REMOVE position removed."
  (append (subseq list 0 index-to-remove)
          (subseq list (1+ index-to-remove))))
