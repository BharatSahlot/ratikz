#lang racket

(require "../src/style.rkt")
(require "../src/connectors.rkt")
(require "../src/commands.rkt")
(require "../src/point.rkt")
(require "../src/ratikz.rkt")

(define my-tree
  (list
    '((0))
    '((1 2 3))
    '((4 5) (6) (7 8))
    '((9 10 11) (12 13) ("text") (15 16) (17 18))
    '(() () () (20) (22) (19) (23) (21) () ())))

(define tree-node-style
  (new style% (shape "circle") (draw "red")))

;; gen points
(define (gen-points tree)
  (letrec
    ([loop (lambda (y tr parent)
             (match tr
               ['() '()]
               [_
                 (letrec ([loop2 (lambda (i tot-x)
                                   (if (= i (length (first tr))) '()
                                     (let ([par (if (= y 0) #false (list-ref parent (* 2 i)))]
                                           [rst (loop2 (+ i 1) 
                                                       (+ tot-x (length (list-ref (first tr) i))))]
                                           [lst (list-ref (first tr) i)])
                                       (letrec ([loop3 (lambda (j)
                                                         (if (= j (length lst)) '()
                                                           (let ([rst1 (loop3 (+ j 1))]
                                                                 [x-v (+ tot-x j)])
                                                             (let ([my-node
                                                                     (new node%
                                                                      (style tree-node-style)
                                                                      (name (format "node_~a_~a" x-v y))
                                                                      (text (format "~a" (list-ref lst j)))
                                                                      (position (p x-v y)))])
                                                             (append
                                                               (list 
                                                                 my-node
                                                                 (if (boolean? par) '()
                                                                   (draw (new style% (arrow "->"))
                                                                         (list (a-p par "south")
                                                                               (a-p my-node "north"))
                                                                         (list (edge)))))
                                                               rst1)))))])
                                         (append (loop3 0) rst)))))])
                   (let ([nodes
                           (loop2 0 (exact-ceiling (* -0.5 (length (flatten (first tr))))))])
                     (let ([down-tree
                             (loop (- y 1) (rest tr) nodes)])
                       (append nodes down-tree))))]))])
    (loop 0 tree '())))

(display (tikz (gen-points my-tree)))
