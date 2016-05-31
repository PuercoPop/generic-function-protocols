(in-package #:gfp)

;; The First step is to expand into a DEFGENERIC with the
;; :GENERIC-FUNCTION-CLASS option. Afterwards iteratively transform each
;; protocol option to a call to ADD-PROTOCOL-GF. As an extra step, it may be
;; appropriate to remove the generic function from all the protocols it belongs
;; to before.
(defmacro defgeneric (gf-name lambda-list &body options)
  ;; First check if :GENERIC-FUNCTION-CLASS is in OPTIONS. If it is and it not
  ;; GENERIC-FUNCTION-WITH-PROTOCOL raise an error. If it is
  ;; GENERIC-FUNCTION-WITH-PROTOCOL pass the options unmodified to
  ;; %DEFGENERIC. If it the option is not present in OPTIONS, add it.
  "Similar to CL:DEFGENERIC but allows a :protocol OPTIONs."
  (if-let (generic-function-class-option (find :generic-function-class options :key #'car))
    (if (eq 'generic-function-with-protocol (second generic-function-class-option))
        `(%defgeneric ,gf-name ,lambda-list nil ,@options)
        (error "The option :GENERIC-FUNCTION-CLASS *must* be generic-function-with-protocol."))
    `(%defgeneric ,gf-name ,lambda-list nil ,@(cons (list :generic-function-class 'generic-function-with-protocol) options))))

(defmacro %defgeneric (gf-name lambda-list (&body add-protocol-forms) &body options)
  ;; If the :protocol option is present remove, it and add a call to ADD-PROTOCOL-GF
  (if-let (protocol-option-index (position :protocol options :key #'car))
    (let ((protocol-name (second (elt options protocol-option-index))))
      `(%defgeneric ,gf-name ,lambda-list
           ,(cons `(add-protocol-gf #',gf-name ',protocol-name) add-protocol-forms)
         ,@(list-sans-element options protocol-option-index)))
    `(%%defgeneric ,gf-name ,lambda-list ,add-protocol-forms ,@options)))

(defmacro %%defgeneric (gf-name lambda-list (&body add-protocol-forms) &body options)
  `(progn
     ;; XXX: Remove the generic-function by GF-NAME from all protocols before.
     (cl:defgeneric ,gf-name ,lambda-list ,@options)
     ,@(loop :for form :in add-protocol-forms
             :collect form)))
