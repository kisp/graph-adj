;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :graph-adj)

(defun to-adj (graph &optional (nodes (graph:nodes graph)))
  (let ((order (length nodes)))
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

(defun symmetricp (matrix)
  (dotimes (i (array-dimension matrix 0)
              t)
    (dotimes (j (array-dimension matrix 0))
      (unless (eql (aref matrix i j)
                   (aref matrix j i))
        (return-from symmetricp nil)))))

(defun build-edges (graph nodes)
  (let (result)
    (dotimes (i (array-dimension graph 0) result)
      (dotimes (j (array-dimension graph 0))
        (let ((bit (aref graph i j)))
          (check-type bit bit)
          (when (eql 1 bit)
            (push (list (nth i nodes) (nth j nodes))
                  result)))))))

(defun from-adj (graph &key nodes (class 'graph:digraph))
  (assert (eql (array-dimension graph 0)
               (array-dimension graph 1)))
  (when (eql 'graph:graph (class-name (find-class class)))
    (assert (symmetricp graph)))
  (graph:populate (make-instance class)
                  :nodes nodes
                  :edges (build-edges graph nodes)))
