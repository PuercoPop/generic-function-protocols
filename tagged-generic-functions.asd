(in-package #:asdf-user)

(defsystem #:tagged-generic-functions
  :serial t
  :depends-on (#:alexandria
               #:closer-mop
               #:hash-set
               #:lisp-namespace)
  :pathname "src/"
  :components ((:file "package")
               (:file "utils")
               (:file "main")
               (:file "syntax")))
