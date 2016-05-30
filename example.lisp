(defpackage #:example
  (:use #:cl))

(in-package #:example)

(tgf:defgeneric point-x (point)
  (:documentation "Return the X component of a POINT.")
  (:generic-function-class tgf:tagged-generic-function)
  (:protocol point)
  (:protocol :geometry))

(tgf:defgeneric point-x (point)
  (:documentation "Return the X component of a POINT.")
  (:generic-function-class standard-generic-function)
  (:protocol point)
  (:protocol geometry))

(defgeneric point-x (point)
  (:documentation "Return the X component of a POINT.")
  (:tags point
         geometry))
