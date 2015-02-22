;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package :asdf-user)

(defsystem :graph-adj
  :name "graph-adj"
  :description "Simple graph adjacency matrix representation."
  :author "Kilian Sprotte <kilian.sprotte@gmail.com>"
  :version #.(with-open-file
                 (vers (merge-pathnames "version.lisp-expr" *load-truename*))
               (read vers))
  :components ((:static-file "version" :pathname #p"version.lisp-expr")
               (:file "package")
               (:file "graph-adj" :depends-on ("package"))
               )
  :depends-on (:alexandria :graph))

(defmethod perform ((op test-op)
                    (system (eql (find-system :graph-adj))))
  (oos 'load-op :graph-adj-test)
  (funcall (intern "RUN!" "MYAM") :graph-adj-test))
