;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :graph-adj-test)

(defsuite* :graph-adj-test)

(defun edgequal (a b)
  (set-equal a b :test #'equal))

#-sbcl
(defun mequal (a b)
  (assert (eql 2 (length (array-dimensions a))))
  (and (equal (array-dimensions a) (array-dimensions b))
       (block top
         (dotimes (i (first (array-dimensions a))
                     t)
           (dotimes (j (second (array-dimensions a)))
             (when (not (eql (aref a i j)
                             (aref b i j)))
               (return-from top nil)))))))

#+sbcl
(defun mequal (a b)
  (equalp a b))

(deftest test.1
  (is (mequal #2A((0 0)
                  (0 0))
              (to-adj (populate (make-instance 'digraph) :nodes '(a b))))))

(deftest test.2
  (is (mequal #2A((0 0 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'digraph) :nodes '(a b c))))))

(deftest test.3
  (is (mequal #2A((0 1 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b)))
                      '(a b c)))))

(deftest test.4
  (is (mequal #2A((0 1 0)
                  (0 0 0)
                  (0 0 1))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b) (c c)))
                      '(a b c)))))

(deftest test.5
  (is (mequal #2A((0 0)
                  (0 0))
              (to-adj (populate (make-instance 'graph) :nodes '(a b))))))

(deftest test.6
  (is (mequal #2A((0 0 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'graph) :nodes '(a b c))))))

(deftest test.7
  (is (mequal #2A((0 1 0)
                  (1 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'graph)
                                :nodes '(a b c)
                                :edges '((a b)))
                      '(a b c)))))

(deftest test.8
  (is (mequal #2A((0 1 0)
                  (1 0 0)
                  (0 0 1))
              (to-adj (populate (make-instance 'graph)
                                :nodes '(a b c)
                                :edges '((a b) (c c)))
                      '(a b c)))))

(deftest test.9
  (is (mequal #2A((0 1 1)
                  (0 0 0)
                  (1 0 0))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b) (c a) (a c)))
                      '(a b c)))))

(deftest test.10
  (let ((graph
          (from-adj #2A((0 0 0)
                        (0 0 0)
                        (0 1 0))
                    :nodes '(a b c))))
    (is (equal '(a b c) (nodes graph)))
    (is (edgequal '((c b)) (edges graph)))))

(deftest test.11
  (let ((graph
          (from-adj #2A((0 0 0)
                        (1 0 0)
                        (0 1 1))
                    :nodes '(a b c))))
    (is (equal '(a b c) (nodes graph)))
    (is (edgequal '((c b) (c c) (b a)) (edges graph)))))

(deftest test.12
  (signals error
    (from-adj #2A((0 0 0)
                  (1 0 0)
                  (0 1 1))
              :nodes '(a b c)
              :class 'graph)))

(deftest test.13
  (let ((graph
          (from-adj #2A((0 1 0)
                        (1 0 0)
                        (0 0 0))
                    :nodes '(a b c)
                    :class 'graph)))
    (is (equal '(a b c) (nodes graph)))))
