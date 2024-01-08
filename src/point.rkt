#lang racket

(define point-base%
  (class object%
    (super-new)
    (define/public (render) "render called on point base")))

(define point%
  (class point-base%
    (super-new)
    (init-field x y)
    (define/override (render) (format "(~a,~a)" x y))))

(define cycle%
  (class point-base%
    (super-new)
    (define/override (render) "cycle")))

(define anchor-point%
  (class point-base%
    (super-new)
    (init-field node anchor)
    (define/override (render)
      (format "(~a.~a)"
              (get-field name node)
              anchor))))

(define p
  (lambda (x y)
    (new point% (x x) (y y))))

(define cycle (new cycle%))

(define a-p
  (lambda (node anchor)
    (new anchor-point% (node node) (anchor anchor))))

(provide point% p cycle% cycle anchor-point% a-p)
