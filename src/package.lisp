(defpackage #:tagged-generic-functions
  (:use #:cl
        #:hash-set
        #:lisp-namespace)
  (:import-from #:alexandria
                #:if-let
                #:when-let)
  (:shadow #:defgeneric)
  (:nicknames #:tgf)
  (:export
   #:defgeneric
   #:tagged-generic-function))
