#lang send-exp racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (describe obj)
  (printf "Hello ~a\n" obj))

(define table%
  (class object%
    (define {describe-self self}
      (describe self))
    (super-new)))

{describe-self (new table%)}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define account%
  (class object%
    (super-new)
    (init-field balance)
    (define {add self n}
      (new this% [balance (+ n balance)]))))

(define savings%
  (class account%
    (super-new)
    (inherit-field balance)
    (define interest 0.04)
    (define {add-interest self}
      {add self (* interest balance)})))

(let* ([acct (new savings% [balance 500])]
       [acct {add acct 500}]
       [acct {add-interest acct}])
  (printf "Current balance: ~a\n" (get-field balance acct)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define x% (class object%
	     (super-new)
	     (define {foo self}
	       (printf "in foo\n")
	       (printf "zot: ~v\n" {zot self})
	       self)
	     (define {zot self}
	       444)
	     (define {bar self}
	       123)))

{bar {foo (new x%)}}
