#lang racket

(require "../src/ratikz.rkt")

(display
  (let ([base-style (new style% (draw "gray"))])
    (tikz
      (draw base-style (list (p -2 0) (p 2 0)) (list (edge)))
      (filldraw base-style (list (p 0 0)) (list (circle 2)))
      (draw base-style (list (p -2 -2) (p 2 -2)) (list (curve (p 0 0))))
      (draw base-style (list (p -2 2) (p 2 2)) (list (curve (p -1 0) (p 1 0))))
      )))
