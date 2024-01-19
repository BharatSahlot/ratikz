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

(define count-nodes
  ())

(define (unparse exp is-root? edge-label level)
  (let ([children
          (cases ast exp
                 (binop (op l r)
                        (list (unparse l #f #f (+ level 1)) (unparse r #f #f (+ level 1))))
                 (ifte (c t e)
                       (list (unparse c #f "test" (+ level 1))
                             (unparse t #f "then" (+ level 1))
                             (unparse e #f "else" (+ level 1))))
                 (num (n) '())
                 (bool (b) '()))])
    (if is-root?
      (new tree-root%
           (name "root")
           (style (new style%))
           (text (get-string exp))
           (children children))
      (new tree-node% ;; depending on the context style properties can be easily set
           (text (get-string exp))
           (children children)
           (style (new style% (sibling-distance (/ 150.0 level))))
           (edge-label edge-label)
           (edge-style (new style% 
                            (text-color (if (eq? edge-label "test") "green!50" "blue!50"))
                            (fill "white")
                            (font "\\tiny")))))))

;; INFO: this creates a very overlapping ast, tikz does not handle that by itself
(display
  (tikz (unparse (parse '(if (== 8 (if (== 6 (* 2 3)) 3 5)) (* 10 (if (== 6 (* 2 3)) 3 5)) 20)) #t #f 1)))

;; (display
;;   (tikz (unparse (parse '(if (== 8 4) (* 10 (if (== 6 (* 2 3)) 3 5)) 20)) #t #f 1)))
