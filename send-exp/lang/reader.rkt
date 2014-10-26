(module reader syntax/module-reader
  #:language read
  #:wrapper1
  (lambda (t)
    (list* #'(require (only-in racket/class send))
           '(require send-exp/lang)
           (t)))
  #:wrapper2
  (let ((send-readtable (make-readtable (current-readtable)
					#\{
					'terminating-macro
					(lambda (ch in src line col position)
					  (syntax-case (read-syntax/recursive src in ch #f) ()
					    [(selector)
					     #'(lambda (receiver) (send receiver selector))]
					    [(selector receiver arg ...)
					     #'(send receiver selector arg ...)])))))
    (lambda (in rd stx?)
      (parameterize ((current-readtable send-readtable))
	(if stx?
	    (rd in)
	    (syntax->datum (rd in)))))))
