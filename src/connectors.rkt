#lang racket

(define connector-base%
  (class object%
    (super-new)
    (init-field [nodes '()])
    (define/public (render)
      (string-join (map (lambda (n) (send n render)) nodes) " "))))

(define circle%
  (class connector-base%
    (super-new)
    (init-field radius)
    (define/override (render) (format "circle (~apt) ~a" radius (super render)))))

(define edge%
  (class connector-base%
    (super-new)
    (define/override (render) (format "-- ~a" (super render)))))

(define rectangle%
  (class connector-base%
    (super-new)
    (define/override (render) (format "rectangle ~a" (super render)))))

(define node%
  (class connector-base%
    (super-new)
    (init-field [text ""])
    (init-field [anchor #false])
    (define/override (render)
      (if anchor
        (format "node[anchor=~a]{~a}" anchor text)
        (format "node{~a}" text)))))

(define curve%
  (class connector-base%
    (super-new)
    (init-field [control-points '()])
    (define/override (render)
      (format ".. controls ~a .."
              (string-join (map (lambda (point)
                                  (send point render))
                                control-points)
                           " and ")))))

(define ellipse%
  (class connector-base%
    (super-new)
    (init-field [radius '()])
    (define/override (render)
      (format "ellipse (~a)"
              (string-join (map (lambda (point)
                                  (~a point))
                                radius)
                           " and ")))))

(define arc%
  (class connector-base%
    (super-new)
    (init-field [s-angle 0]
                [e-angle 1]
                [radius 0])
    (define/override (render)
      (format "arc (~a:~a:~a)"
              s-angle
              e-angle
              radius))))

(define grid%
  (class connector-base%
    (super-new)
    (define/override (render) "grid")))

(define circle
  (lambda (radius . nodes)
    (new circle% (radius radius) (nodes nodes))))

(define edge
  (lambda nodes
    (new edge% (nodes nodes))))

(define rectangle
  (lambda nodes
    (new rectangle% (nodes nodes))))

(define node
  (lambda lst
    (match lst
      [(list) (new node% (text "") (anchor #false))]
      [(list a) (new node% (text a) (anchor #false))]
      [(list a b) (new node% (text a) (anchor b))])))

(define curve
  (lambda (a . nodes)
    (new curve% 
         (control-points 
           (if (> (length nodes) 0)
             (list a (first nodes))
             (list a)))
         (nodes
           (if (> (length nodes) 1)
             (rest nodes)
             '())))))

(define ellipse
  (lambda (xr yr . nodes)
    (new ellipse% (radius (list xr yr)) (nodes nodes))))

(define arc
  (lambda (start-angle end-angle radius . nodes)
    (new arc% (s-angle start-angle)
         (e-angle end-angle)
         (radius radius)
         (nodes nodes))))

(define grid
  (lambda nodes
    (new grid% (nodes nodes))))

(provide circle edge rectangle node curve ellipse arc grid)
