;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :graph-adj)

(defun vector2cons (order vector)
  (cons order
        (loop for i from (1- (length vector)) downto 0
              for pos = 1 then (* 2 pos)
              summing (* pos (aref vector i)))))

(defun cons2vector (cons)
  (destructuring-bind (order . integer) cons
    (let* ((length (* order order))
           (array (make-array length :element-type 'bit)))
      (dotimes (i length)
        (setf (aref array (- (1- length) i))
              (if (logbitp i integer) 1 0)))
      array)))

(defun to-adj (graph &key
                       (type 'array)
                       (nodes (graph:nodes graph)))
  "NODES can be specified here, because the GRAPH object might not
know its nodes in the correct order (due to hash-tables)."
  (to-adj* graph type nodes))

(defgeneric to-adj* (graph type nodes)
  (:method (graph (type (eql 'array)) nodes)
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
  (:method (graph (type (eql 'cons)) nodes)
    (let* ((array (to-adj* graph 'array nodes))
           (order (array-dimension array 0))
           (vector (make-array (* order order)
                               :displaced-to array
                               :element-type 'bit)))
      (vector2cons order vector))))

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

(defun from-adj (graph &key
                         nodes
                         (class 'graph:digraph))
  (from-adj* graph nodes class))

(defgeneric from-adj* (graph nodes class)
  (:method ((graph array) nodes class)
    (let ((nodes (or nodes
                     (iota (array-dimension graph 0)))))
      (assert (eql (array-dimension graph 0)
                   (array-dimension graph 1)))
      (when (eql 'graph:graph (class-name (find-class class)))
        (assert (symmetricp graph)))
      (graph:populate (make-instance class)
                      :nodes nodes
                      :edges (build-edges graph nodes))))
  (:method ((graph cons) nodes class)
    (let ((order (car graph)))
      (from-adj* (make-array (list order order)
                             :displaced-to (cons2vector graph)
                             :element-type 'bit)
                 nodes class))))
