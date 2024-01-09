#lang racket

(require "../src/ratikz.rkt")

(display
  (let ([circle-style (new style% 
                           (draw "red!60")
                           (fill "red!5")
                           (thickness "very thick"))])
    (tikz
      (filldraw circle-style 
                (list (p -1 0))
                (list (circle 25)))
      (fill (new style% 
                 (fill "blue!50"))
            (list (p 2.5 0))
            (list (ellipse 1.5 0.5)))
      (draw (new style% 
                 (thickness "ultra thick")
                 (arrow "->"))
            (list (p 6.5 0))
            (list (arc 0 220 1)))
      )))
