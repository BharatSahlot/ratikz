#lang racket

(require "../src/ratikz.rkt")

(display
  (let ([grid-style (new style% 
                           (draw "gray")
                           (thickness "very thin")
                           (step 0.5))]
        [x-points (list -1 -0.5 0.5 1)]
        [y-points (list -1 -0.5 0.5 1)])
    (tikz
      (draw grid-style
            (list (p -1.4 -1.4) (p 1.4 1.4))
            (list (grid)))
      (draw (def-style)
            (list (p -1.5 0) (p 1.5 0))
            (list (edge)))
      (draw (def-style)
            (list (p 0 -1.5) (p 0 1.5))
            (list (edge)))
      (draw (def-style)
            (list (p 0 0))
            (list (circle 25)))
      (shadedraw (new style%
                 (left-color "gray")
                 (right-color "green")
                 (draw "green!50!black"))
            (list (p 0 0) (p 0.3 0))
            (list (edge) (arc 0 30 0.3) (edge cycle)))
      (map (lambda (x)
             (draw (new style% (font "\\tiny"))
                   (list (p x 0.1) (p x -0.1))
                   (list (edge (node (~a x) "north")))))
           x-points)
      (map (lambda (y)
             (draw (new style% (font "\\tiny"))
                   (list (p 0.1 y) (p -0.1 y))
                   (list (edge (node (~a y) "east")))))
           y-points)
            )))
