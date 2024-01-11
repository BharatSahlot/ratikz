#lang racket

(require "../src/ratikz.rkt")

(display
  (tikz
    (new tree-root%
         (name "root")
         (style (new style% (text-color "red")))
         (text "root")
         (children (list
                     (new tree-node%
                          (text "child-1")
                          (style (new style% (text-color "blue!50")))
                          (children (list
                                      (new tree-node%
                                           (text "grandchild-1")))))
                     (new tree-node%
                          (text "child-2")))))))
