(defpackage #:example
  (:use #:cl))

(in-package #:example)

(gfp:defgeneric point-x (point)
  (:documentation "Return the X component of a POINT.")
  (:protocol point)
  (:protocol geometry))

(gfp:defgeneric point-x (point)
  (:documentation "Return the X component of a POINT.")
  (:generic-function-class gfp:generic-function-with-protocol)
  (:protocol point)
  (:protocol :geometry))

;; This should raise an error
(gfp:defgeneric point-x (point)
  (:documentation "Return the X component of a POINT.")
  (:generic-function-class standard-generic-function)
  (:protocol point)
  (:protocol geometry))

;; Consider implementing this syntax
(defgeneric point-x (point)
  (:documentation "Return the X component of a POINT.")
  (:protocols point
              geometry))
