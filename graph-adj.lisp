;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :graph-adj)

(defun to-adj (graph)
  (let* ((nodes (graph:nodes graph))
         (order (length nodes)))
    (let ((matrix (make-array (list order order) :element-type 'bit)))
      (labels ((set-edge (edge)
                 (destructuring-bind (x y) edge
                   (setf (aref matrix
                               (position x nodes)
                               (position y nodes))
                         1))))
        (dolist (edge (graph:edges graph))
          (set-edge edge)
          (unless (typep graph 'graph:digraph)
            (set-edge (reverse edge)))))
      matrix)))
