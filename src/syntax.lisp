(in-package #:tgf)

;; The First step is to expand into a DEFGENERIC with the
;; :GENERIC-FUNCTION-CLASS option. Afterwards iteratively transform each
;; protocol option to an TAG-GF. As a bonus clear all the tags of the generic
;; function before processing a generic function.
(defmacro defgeneric (gf-name lambda-list &body options)
  ;; First check if :GENERIC-FUNCTION-CLASS is in OPTIONS. If it is and it not
  ;; TAGGED-GENERIC-FUNCTION raise an error. If it is TAGGED-GENERIC-FUNCTION
  ;; pass the options unmodified to %DEFGENERIC. If it the option is not
  ;; present in OPTIONS, add it.
  "Similar to CL:DEFGENERIC but allows a :protocol OPTIONs."
  (if-let (generic-function-class-option (find :generic-function-class options :key #'car))
    (if (eq 'tagged-generic-function (second generic-function-class-option))
        `(%defgeneric ,gf-name ,lambda-list nil ,@options)
        (error "The option :GENERIC-FUNCTION-CLASS *must* be tagged-generic-function."))
    `(%defgeneric ,gf-name ,lambda-list nil ,@(cons (cons :generic-funciton-class 'tagged-generic-function) options))))

(defmacro %defgeneric (gf-name lambda-list (&body add-tag-forms) &body options)
  ;; If the :protocol option is present remove, it and add a call to ADD-TAG
  (if-let (protocol-option-index (position :protocol options :key #'car))
    (let ((protocol-name (second (elt options protocol-option-index))))
      `(%defgeneric ,gf-name ,lambda-list
           ,(cons `(add-tag-gf #',gf-name ',protocol-name) add-tag-forms)
         ,@(list-sans-element options protocol-option-index)))
    `(%%defgeneric ,gf-name ,lambda-list ,add-tag-forms ,@options)))

(defmacro %%defgeneric (gf-name lambda-list (&body add-tag-forms) &body options)
  `(progn
     ;; XXX: Remove all current tags for GF-NAME here
     (cl:defgeneric ,gf-name ,lambda-list ,@options)
     ,@(loop :for form :in add-tag-forms
             :collect form)))
