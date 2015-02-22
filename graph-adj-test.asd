;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :asdf-user)

(defsystem :graph-adj-test
  :name "graph-adj-test"
  :description "Tests for graph-adj"
  :components ((:module "test"
                :components ((:file "package")
                             (:file "test" :depends-on ("package")))))
  :depends-on (:graph-adj :myam :alexandria))

(defmethod perform ((op test-op)
                    (system (eql (find-system :graph-adj-test))))
  (perform op (find-system :graph-adj)))
