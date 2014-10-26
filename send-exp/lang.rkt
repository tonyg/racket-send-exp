#lang racket/base

(require (for-syntax racket/base))
(require (only-in racket/class
		  send
		  define/public
		  define/override
		  this))

(provide (rename-out [send:define define]
		     [send:define/override define/override]))

(define-syntax (send:define stx)
  (syntax-case stx (send)
    [(_ (send receiver selector arg ...) body ...)
     #'(define/public (selector arg ...)
	 (let ((receiver this))
	   body ...))]
    [(_ other ...)
     #'(define other ...)]))

(define-syntax (send:define/override stx)
  (syntax-case stx (send)
    [(_ (send receiver selector arg ...) body ...)
     #'(define/override (selector arg ...)
	 (let ((receiver this))
	   body ...))]
    [(_ other ...)
     #'(define/override other ...)]))
