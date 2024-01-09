#lang racket

(require "./commands.rkt")
(require "./connectors.rkt")
(require "./point.rkt")
(require "./style.rkt")

(define (document #:class class . body)
  (format
    (~a "\\documentclass{" class "}\n"
        "\\usepackage{tikz}\n"
        "\\usetikzlibrary{positioning}\n"
        "\\begin{document}\n"
        "~a"
        "\\end{document}\n")
    (foldl string-append "" body)))

(define tikzpicture
  (lambda obj-list
    (letrec ([loop (lambda (lst)
                     (if (= (length lst) 0)
                       "\n"
                       (format "\n~a;~a" (send (first lst) render) (loop (rest lst)))))])
      (format
        (~a "\\begin{tikzpicture}\n"
                "~a"
            "\\end{tikzpicture}\n")
        (foldl (lambda (a b)
             (format "~a~a;\n" b (send a render))) "" (flatten obj-list))))))

(define tikz
  (lambda obj-list
    (document 
      #:class "standalone"
      (tikzpicture obj-list))))

(provide tikz)
(provide document)
(provide tikzpicture)

(provide (all-from-out "./commands.rkt")
         (all-from-out "./connectors.rkt")
         (all-from-out "./point.rkt")
         (all-from-out "./style.rkt"))
