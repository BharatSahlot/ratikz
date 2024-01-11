#lang racket

(require "commands.rkt")

(define tree-root%
  (class node%
    (super-new)
    (inherit-field name style text)
    (init-field [children '()]
                [children-style #false])
    (inherit get-position-string)
    (define/private (render-children)
      (let ([txt (map (lambda (a)
                        (send a render 1))
                      children)])
        (string-join txt "")))
    (define/override (render)
      (let ([pos-string (get-position-string)]
            [chd-txt (render-children)])
        (format
          "\\node~a (~a) ~a {~a} ~a~a"
          (send style render)
          name
          pos-string
          text
          (if (boolean? children-style) "" (send children-style render))
          chd-txt)))))

(define tree-node%
  (class object%
    (super-new)
    (init-field [name #false]
                [style #false]
                [text #false]
                [node-style #false]
                [children '()]
                [edge-label #false])
    (define/public (render-children level)
      (let ([lst (map (lambda (a)
                        (send a render (+ level 1))) children)])
        (if (empty? lst) ""
          (string-join lst ""))))
    (define/public (render level)
      (format
        "\n~achild~a { node~a~a {~a} ~a ~a}"
        (make-string level #\tab)
        (if (boolean? style) "" (send style render))
        (if (boolean? node-style) "" (send node-style render))
        (if (boolean? name) "" (format " (~a) "))
        text
        (render-children (+ level 1))
        (if (boolean? edge-label) ""
          (format "\nedge from parent node {~a}" edge-label))))))

(provide tree-root% tree-node%)
