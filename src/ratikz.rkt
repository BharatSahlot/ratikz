#lang racket

(define tikz
  (lambda obj-list
    (letrec ([loop (lambda (lst)
                     (if (= (length lst) 0)
                       "\n"
                       (format "\n~a;~a" (send (first lst) render) (loop (rest lst)))))])
      (format
        "\\documentclass{article}\n\\usepackage{tikz}\n\\usetikzlibrary{positioning}\n\\begin{document}\n\\begin{tikzpicture}~a\\end{tikzpicture}\n\\end{document}\n"
        (loop (flatten obj-list))))))

(provide tikz)
