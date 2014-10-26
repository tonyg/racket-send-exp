# Convenient OO message sending for Racket

## Invoking methods

In Racket, invoking a message `foo` on an object `bar` is done with

```racket
 #lang racket
 ...
 (send bar foo arg1 arg2 ...)
```

To make this a little more convenient, prefix your language
specification with `send-exp`, and use curly-braces instead:

```racket
 #lang send-exp racket
 ...
 {foo bar arg1 arg2 ...}
```

Note that the selector comes *first*, with the receiver argument
coming *second*.

## Defining methods

In addition, using `#lang send-exp ...` adds new syntax for defining
methods in a class. In addition to the normal ways of defining a
method, you can also use `(define {method self arg ...} ...)` and
`(define/override {method self arg ...} ...)`:

```racket
 #lang send-exp racket
 ...
 (class object%
 	...
 	(define {foo self arg1 arg2 ...}
 		...))
```

The syntax

```racket
 (define {selector receiver arg ...) body ...)
```

is equivalent to

```racket
 (define/public (selector arg ...)
 	(let ((receiver this))
 		body ...))

```

and `define/override` with curly-braces is analogously equivalent to a
use of the underlying `define/override` syntax.

## Abstracting over method calls

In addition to the above, you can use `{method}` anywhere you would
use `(lambda (receiver) {method receiver})`. This only works for unary
methods at present.
