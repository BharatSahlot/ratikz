#lang racket

(define safe-format
  (lambda (str val)
    (if (boolean? val) #false
      (format str val))))

(define style%
  (class object%
    (super-new)
    (init-field [shape      #false]
                [draw       #false]
                [fill       #false]
                [thickness  #false]
                [arrow      #false]
                [text-color #false]
                [font       #false]
                [step       #false]
                [xstep      #false]
                [ystep      #false]
                [left-color #false]
                [right-color #false]
                [min-size   #false]
                [sibling-distance #false])
    (define/public (render)
      (let ([shape-str (safe-format "~a" shape)]
            [draw-str (safe-format "draw=~a" draw)]
            [fill-str (safe-format "fill=~a" fill)]
            [thick-str (safe-format "~a" thickness)]
            [arrow-str (safe-format "~a" arrow)]
            [text-str (safe-format "text=~a" text-color)]
            [font-str (safe-format "font=~a" font)]
            [step-str (safe-format "step=~acm" step)]
            [xstep-str (safe-format "xstep=~acm" xstep)]
            [ystep-str (safe-format "ystep=~acm" ystep)]
            [leftc-str (safe-format "left color=~a" left-color)]
            [rightc-str (safe-format "right color=~a" right-color)]
            [minsize-str (safe-format "minimum size=~a" min-size)]
            [sibdist-str (safe-format "sibling distance=~a" sibling-distance)]
            )
        (let ([lst (filter string?
                     (list shape-str draw-str fill-str thick-str arrow-str text-str font-str
                           step-str xstep-str ystep-str leftc-str rightc-str minsize-str
                           sibdist-str))])
          (format "[~a]" (string-join lst ", ")))))))

(define def-style
  (lambda ()
    (new style%)))

(provide style% def-style)
