;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :graph-adj-test)

(defsuite* :graph-adj-test)

(deftest test.1
  (is (equalp #2A((0 0)
                  (0 0))
              (to-adj (populate (make-instance 'digraph) :nodes '(a b))))))

(deftest test.2
  (is (equalp #2A((0 0 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'digraph) :nodes '(a b c))))))

(deftest test.3
  (is (equalp #2A((0 1 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b)))))))

(deftest test.4
  (is (equalp #2A((0 1 0)
                  (0 0 0)
                  (0 0 1))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b) (c c)))))))

(deftest test.5
  (is (equalp #2A((0 0)
                  (0 0))
              (to-adj (populate (make-instance 'graph) :nodes '(a b))))))

(deftest test.6
  (is (equalp #2A((0 0 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'graph) :nodes '(a b c))))))

(deftest test.7
  (is (equalp #2A((0 1 0)
                  (1 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'graph)
                                :nodes '(a b c)
                                :edges '((a b)))))))

(deftest test.8
  (is (equalp #2A((0 1 0)
                  (1 0 0)
                  (0 0 1))
              (to-adj (populate (make-instance 'graph)
                                :nodes '(a b c)
                                :edges '((a b) (c c)))))))

(deftest test.9
  (is (equalp #2A((0 1 1)
                  (0 0 0)
                  (1 0 0))
              (to-adj (populate (make-instance 'digraph)
                                :nodes '(a b c)
                                :edges '((a b) (c a) (a c)))))))
