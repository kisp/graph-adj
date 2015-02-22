;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :graph-adj-test)

(defsuite* :graph-adj-test)

(deftest dummy
  (is (= 1 1)))

(deftest test.1
  (is (equalp #2A((0 0 0)
                  (0 0 0)
                  (0 0 0))
              (to-adj (populate (make-instance 'graph) :nodes '(a b c))))))
