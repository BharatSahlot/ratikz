#lang racket

(require "../src/ratikz.rkt")

(define (unzip lst)
  (if (null? lst)
      '(() ())
      (let ([a (first (first lst))]
            [b (second (first lst))]
            [rst (unzip (rest lst))])
        (list (append (list a) (first rst)) (append (list b) (second rst))))))

(display
  (let ([lst (unzip (map (lambda (i)
                           (list (p i i) (if (= i 2) (rectangle) (circle i))))
                         (inclusive-range 1 6)))])
    (let ([points (first lst)]
          [mpoints (map (lambda (x)
                     (p (- 12 (get-field x x)) (get-field y x))) (first lst))])
      (tikz
        ;; (draw
        ;;   (new style% (draw "yellow") (fill "blue!50"))
        ;;   points (second lst))
        ;; (draw
        ;;   (new style% (thickness "thick"))
        ;;   points (map (lambda (_) (edge)) (inclusive-range 1 5 2)))
        ;; (draw
        ;;   (new style% (draw "blue") (fill "yellow!50"))
        ;;   mpoints (second lst))
        (draw (new style% (fill "yellow!50"))
              (list (p 4 0) (p 6 0) (p 5.7 2) cycle)
              (list (edge) (edge) (edge)))
        ))))
