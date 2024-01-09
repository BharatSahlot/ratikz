#lang racket

(require "../src/ratikz.rkt")

(display
  (let ([roundnode
          (new style%
               (shape "circle")
               (draw "green!60")
               (fill "green!5")
               (thickness "very thick")
               (min-size 0.7))]
        [squarednode
          (new style%
               (shape "rectangle")
               (draw "red!60")
               (fill "red!5")
               (thickness "very thick")
               (min-size 0.5))]
        [arrow-style
          (new style%
               (arrow "->"))]
        )
    (let
      ([maintopic (new node% (style squarednode) (name "maintopic") (text "2"))])
      (let ([uppercircle (new node% (style roundnode) (name "uppercircle") (above maintopic) (text "1"))]
            [rightsquare (new node% (style squarednode) (name "rightsquare") (right maintopic) (text "3"))]
            [lowercircle (new node% (style roundnode) (name "lowercircle") (below maintopic) (text "4"))])
        (tikz
          maintopic uppercircle rightsquare lowercircle
          (draw arrow-style
                (list (a-p uppercircle "south") (a-p maintopic "north"))
                (list (edge)))
          (draw arrow-style
                (list (a-p maintopic "east") (a-p rightsquare "west"))
                (list (edge)))
          (draw arrow-style
                (list (a-p rightsquare "south") (a-p lowercircle "east"))
                (list (edge)))
          )))))
