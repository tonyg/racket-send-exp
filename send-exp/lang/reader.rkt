(module reader syntax/module-reader
  #:language read
  ;; #:wrapper1
  ;; (lambda (t)
  ;;   (list* ;;'(require (only-in racket/class send))
  ;;          '(require send-exp/lang)
  ;;          (t)))
  #:wrapper2
  (let* ((wrap (make-syntax-introducer #t))
         (send-readtable (make-readtable (current-readtable)
                                         #\{
                                         'terminating-macro
                                         (lambda (ch in src line col position)
                                           (wrap
                                            (syntax-case (read-syntax/recursive src in ch #f) ()
                                              [(selector)
                                               #`(lambda (receiver) (send receiver
                                                                          #,(wrap #'selector)))]
                                              [(selector receiver arg ...)
                                               #`(send #,(wrap #'receiver)
                                                       #,(wrap #'selector)
                                                       #,@(wrap #'(arg ...)))]))))))
    (lambda (in rd stx?)
      (parameterize ((current-readtable send-readtable))
        (define (r)
          (syntax-case (rd in) ()
            [(module name lang (#%module-begin . body))
             (let ((make-unhygienic (make-syntax-delta-introducer #'require #'module)))
               (wrap
                #`(module name lang
                    (#%module-begin
                     #,(wrap #'(require (only-in racket/class send)))
                     #,(make-unhygienic #'(require send-exp/lang) 'remove)
                     . body))))]))
        (if stx?
            (r)
            (syntax->datum (r))))))

  (require (for-syntax racket/base)))
