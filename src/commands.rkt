#lang racket

(define command-base%
  (class object%
    (super-new)
    (init-field style)
    (define/public (render) "error: command-base% render called")))

(define node%
  (class command-base%
    (super-new)
    (inherit-field style)
    (init-field name
                [text ""]
                [above #false]
                [right #false]
                [left #false]
                [below #false]
                [position #false])
    (define/public (get-position-string)
      (let ([above-str (if (boolean? above) #false (format "above=of ~a"    (get-field name above)))]
            [right-str (if (boolean? right) #false (format "right=of ~a"    (get-field name right)))]
            [left-str (if (boolean? left) #false (format "left=of ~a"       (get-field name left)))]
            [below-str (if (boolean? below) #false (format "below=of ~a"    (get-field name below)))]
            [position-str (if (boolean? position) #false (format "at ~a"    (send position render)))])
        (let ([lst (filter string? (list above-str right-str left-str below-str))])
          (format
            "~a ~a"
            (format "[~a]" (string-join lst ", "))
            (if (boolean? position-str) "" position-str)))))
    (define/override (render)
      (let ([pos-string (get-position-string)]) 
        (format
          "\\node~a (~a) ~a {~a}"
          (send style render)
          name
          pos-string
          text)))))

(define mcommand-base%
  (class command-base%
    (super-new)
    (inherit-field style)
    (init-field [points '()]
                [connectors '()])
    (define/override (render)
      (letrec ([loop (lambda (pnts cnts)
                       (if (= (length pnts) 0)
                         (if (= (length cnts) 0) "" (send (first cnts) render))
                         (if (= (length cnts) 0)
                           (send (first pnts) render)
                           (let ([str (loop (rest pnts) (rest cnts))])
                             (format "~a ~a ~a"
                                     (send (first pnts) render)
                                     (if (> (length cnts) 0) (send (first cnts) render) "")
                                     str)))))]) 
        (format "~a ~a" (send style render) (loop points connectors))))))

(define command-mixin
  (lambda (cmd)
    (class mcommand-base%
      (super-new)
      (define/override (render)
        (format "~a~a" cmd (super render))))))

(define draw-obj%
  (command-mixin "\\draw"))

(define fill-obj%
  (command-mixin "\\fill"))

(define filldraw-obj%
  (command-mixin "\\filldraw"))

(define shade-obj%
  (command-mixin "\\shade"))

(define shadedraw-obj%
  (command-mixin "\\shadedraw"))

(define draw
  (lambda (style points connectors)
    (new draw-obj% (style style) (points points) (connectors connectors))))

(define fill
  (lambda (style points connectors)
    (new fill-obj% (style style) (points points) (connectors connectors))))

(define filldraw
  (lambda (style points connectors)
    (new filldraw-obj% (style style) (points points) (connectors connectors))))

(define shade
  (lambda (style points connectors)
    (new shade-obj% (style style) (points points) (connectors connectors))))

(define shadedraw
  (lambda (style points connectors)
    (new shadedraw-obj% (style style) (points points) (connectors connectors))))

(provide draw fill filldraw shade shadedraw node%)
