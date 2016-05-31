(defpackage #:generic-function-protocols
  (:use #:cl
        #:hash-set
        #:lisp-namespace)
  (:import-from #:alexandria
                #:if-let
                #:when-let)
  (:shadow #:defgeneric)
  (:nicknames #:gfp)
  (:export
   #:defgeneric
   #:generic-function-with-protocol
   #:add-protocol-gf
   #:remove-tag-gf
   #:print-protocols
   #:list-functions))
