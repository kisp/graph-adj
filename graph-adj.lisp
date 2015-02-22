;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :graph-adj)

(defun to-adj (graph)
  (let ((order (length (graph:nodes graph))))
    (make-array (list order order) :element-type 'bit)))
