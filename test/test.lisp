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

(deftest test.1.b
  (is (mequal #2A((0 0)
                  (0 0))
              (to-adj (populate (make-instance 'digraph) :nodes '(a b))
                      :type 'array))))

(deftest cons.1
  (is (equal '(2 . 0)
             (to-adj (populate (make-instance 'digraph) :nodes '(a b))
                     :type 'cons))))

(deftest test.2
  (is (mequal #2A((0 0 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'digraph) :nodes '(a b c))))))

(deftest cons.2
  (is (equal '(3 . 0)
             (to-adj (populate (make-instance 'digraph) :nodes '(a b c))
                     :type 'cons))))

(deftest test.3
  (is (mequal #2A((0 1 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b)))
                      :nodes '(a b c)))))

(deftest cons.3
  (is (equal '(3 . #b010000000)
             (to-adj (populate (make-instance 'digraph)
                               :nodes '(a b c)
                               :edges '((a b)))
                     :type 'cons))))

(deftest test.4
  (is (mequal #2A((0 1 0)
                  (0 0 0)
                  (0 0 1))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b) (c c)))
                      :nodes '(a b c)))))

(deftest cons.4
  (is (equal '(3 . #b010000001)
             (to-adj (populate (make-instance 'digraph)
                               :nodes '(a b c)
                               :edges '((a b) (c c)))
                     :type 'cons))))

(deftest test.5
  (is (mequal #2A((0 0)
                  (0 0))
              (to-adj (populate (make-instance 'graph) :nodes '(a b))))))

(deftest cons.5
  (is (equal '(2 . 0)
             (to-adj (populate (make-instance 'graph) :nodes '(a b))
                     :type 'cons))))

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
                      :nodes '(a b c)))))

(deftest test.8
  (is (mequal #2A((0 1 0)
                  (1 0 0)
                  (0 0 1))
              (to-adj (populate (make-instance 'graph)
                                :nodes '(a b c)
                                :edges '((a b) (c c)))
                      :nodes '(a b c)))))

(deftest test.9
  (is (mequal #2A((0 1 1)
                  (0 0 0)
                  (1 0 0))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b) (c a) (a c)))
                      :nodes '(a b c)))))

(deftest cons.9
  (is (equal '(3 . #b011000100)
             (to-adj (populate (make-instance 'digraph)
                               :nodes '(a b c)
                               :edges '((a b) (c a) (a c)))
                     :type 'cons))))

(deftest test.10
  (let ((graph
          (from-adj #2A((0 0 0)
                        (0 0 0)
                        (0 1 0))
                    :nodes '(a b c))))
    (is (set-equal '(a b c) (nodes graph)))
    (is (edgequal '((c b)) (edges graph)))))

(deftest cons.10
  (let ((graph
          (from-adj '(3 . #b000000010)
                    :nodes '(a b c))))
    (is (set-equal '(a b c) (nodes graph)))
    (is (edgequal '((c b)) (edges graph)))))

(deftest test.11
  (let ((graph
          (from-adj #2A((0 0 0)
                        (1 0 0)
                        (0 1 1))
                    :nodes '(a b c))))
    (is (set-equal '(a b c) (nodes graph)))
    (is (edgequal '((c b) (c c) (b a)) (edges graph)))))

(deftest cons.11
  (let ((graph
          (from-adj '(3 . #b000100011)
                    :nodes '(a b c))))
    (is (set-equal '(a b c) (nodes graph)))
    (is (edgequal '((c b) (c c) (b a)) (edges graph)))))

(deftest cons.11.b
  (let ((graph
          (from-adj '(3 . #b000100011))))
    (is (set-equal '(0 1 2) (nodes graph)))
    (is (edgequal '((2 1) (2 2) (1 0)) (edges graph)))))

(deftest test.12
  (signals error
    (from-adj #2A((0 0 0)
                  (1 0 0)
                  (0 1 1))
              :nodes '(a b c)
              :class 'graph)))

(deftest test.13
  (skip*) ;not finished yet
  (let ((graph
          (from-adj #2A((0 1 0)
                        (1 0 0)
                        (0 0 0))
                    :nodes '(a b c)
                    :class 'graph)))
    (is (set-equal '(a b c) (nodes graph)))))
