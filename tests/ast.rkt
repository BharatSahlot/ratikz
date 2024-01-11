#lang racket

(require eopl)
(require "../src/ratikz.rkt")

(define-datatype ast ast?
 [binop (op binop?) (rand1 ast?) (rand2 ast?)]
 [ifte (c ast?) (t ast?) (e ast?)]
 [num (n number?)]
 [bool (b boolean?)])

(define binop?
  (lambda (x)
    (match x
      ['add #t]
      ['sub #t]
      ['mul #t]
      ['div #t]
      ['lt? #t]
      ['eq? #t]
      [_ #f])))

(struct exn:parse-error exn:fail ())

(define raise-parse-error 
 (lambda (err-msg)
   (raise (exn:parse-error err-msg (current-continuation-marks)))))

(define (parse exp)
  (cond
  [(number? exp) (num exp)]
  [(boolean? exp) (bool exp)]
  [(list? exp) (match exp
                 [(list '+ exp1 exp2) (binop 'add (parse exp1) (parse exp2))]
                 [(list '- exp1 exp2) (binop 'sub (parse exp1) (parse exp2))]
                 [(list '* exp1 exp2) (binop 'mul (parse exp1) (parse exp2))]
                 [(list '/ exp1 exp2) (binop 'div (parse exp1) (parse exp2))]
                 [(list '< exp1 exp2) (binop 'lt? (parse exp1) (parse exp2))]
                 [(list '== exp1 exp2) (binop 'eq? (parse exp1) (parse exp2))]
                 [(list 'if c l r) (ifte (parse c) (parse l) (parse r))]
                 [_ (raise-parse-error "Not implemented")])]
  [else (raise-parse-error "Not implemented")]))

(define (get-string exp)
  (cases ast exp
         (binop (op l r)
                (op-interpretation op))
         (ifte (c t e) "if")
         (num (n)
              (~a n))
         (bool (b)
               (format "\\~a" b))))

(define op-interpretation
  (lambda (op)
    (match op
      ['add '+]
      ['sub '-]
      ['mul '*]
      ['div '/]
      ['lt? '<]
      ['eq? '=]
      [_ error "unknown op"])))

(define (unparse exp is-root? edge-label)
  (let ([children
          (cases ast exp
                 (binop (op l r)
                        (list (unparse l #f #f) (unparse r #f #f)))
                 (ifte (c t e)
                       (list (unparse c #f "test")
                             (unparse t #f "then")
                             (unparse e #f "else")))
                 (num (n) '())
                 (bool (b) '()))])
    (if is-root?
      (new tree-root%
           (name "root")
           (style (new style%))
           (text (get-string exp))
           (children children))
      (new tree-node%
           (text (get-string exp))
           (children children)
           (edge-label edge-label)))))

(display
  (tikz (unparse (parse '(if (== 8 5) (* 10 (if (== 6 (* 2 3)) 3 5)) 20)) #t #f)))
