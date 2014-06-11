#lang racket/base

(require (for-syntax racket/base))
(require (only-in racket/class send define/public this))

(provide (rename-out [send:define define]))

(define-syntax (send:define stx)
  (syntax-case stx (send)
    [(_ (send receiver selector arg ...) body ...)
     #'(define/public (selector arg ...)
	 (let ((receiver this))
	   body ...))]
    [(_ other ...)
     #'(define other ...)]))
