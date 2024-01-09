#lang racket

(require "../src/ratikz.rkt")

(display
  (let ([base-style (new style% (draw "gray") (thickness "thick"))])
    (tikz
      (draw base-style (list (p -1 2) (p 2 -4)) (list (edge)))
      (draw base-style (list (p -1 -1) (p 2 2)) (list (edge)))
      (filldraw (new style% (fill "black"))
                (list (p 0 0))
                (list (circle 2 (node "Intersection point" "west")))))))
