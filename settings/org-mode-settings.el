(use-package org
  :custom ((org-export-backends '(md odt latex icalendar html ascii)))
  :config
  (add-to-list 'org-file-apps '("\\.pdf\\'" . emacs))
  ;; :bind (("C-c l" . 'org-store-link)
  ;;        :map org-mode-map
  ;;        (("M-i p" . 'org-insert-python-block)
  ;;         ("M-i a" . 'org-insert-align-block)
  ;;         ("M-i * a" . 'org-insert-align-start-block)))

  :hook (org-mode . visual-line-mode)

  ;; :init
  ;; (fset 'org-insert-python-block
  ;;       [?# ?+ ?B ?E ?G ?I ?N ?_ ?S ?R ?C ?  ?p ?y ?t ?h ?o ?n return return ?# ?+ ?E ?N ?D ?_ ?S ?R ?C ?\C-p])
  ;; (fset 'org-insert-align-star-block
  ;;       [?\\ ?b ?e ?g ?i ?n ?\{ ?a ?l ?i ?g ?n ?* ?\} return return ?\\ ?e ?n ?d ?\{ ?a ?l ?i ?g ?n ?* ?\} up])
  ;; (fset 'org-insert-align-block
  ;;       [?\\ ?b ?e ?g ?i ?n ?\{ ?a ?l ?i ?g ?n ?\} return return ?\\ ?e ?n ?d ?\{ ?a ?l ?i ?g ?n ?\} up])
  ;; :config
  ;; (org-babel-do-load-languages
  ;;  'org-babel-load-languages
  ;;  '((python . t)))
  ;; (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))
  ;; (advice-add 'org-create-formula-image :around #'org-renumber-environment)
  ;; :custom
  ;; (org-startup-with-inline-images t)
  ;; (org-support-shift-select t)
  ;; (org-image-actual-width nil)
  ;; (org-babel-python-command "python3")
  ;; (org-startup-indented t) ; Enable `org-indent-mode' by default
  ;; ;; Scale latex images
  ;; (org-latex-pdf-process (list "latexmk -xelatex -f %f"))
  )

(use-package org-ref
  :config
  (define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)
  (setq org-ref-default-type "Cref")
  :after org)

(require 'org-ref-ivy)

;; (use-package org-noter
;;   :after org
;;   :config (setq org-noter-notes-search-path '("~/orgmode/notes")))


(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode)
  :config
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.75))
  (add-to-list 'org-latex-packages-alist
               '("" "tikz" t))

  (eval-after-load "preview"
    '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t))
  (setq org-latex-create-formula-image-program 'imagemagick)
  )
;; ORG-AGENDA settings
;; references:
;;    http://www.personal.psu.edu/bam49/notebook/org-mode-for-research/
(setq org-agenda-files
      (file-expand-wildcards "~/orgmode/*.org"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "SOMEDAY(s)" "PROJ(p)" "|" "DONE(d)" "CANCELLED(c)")))

(setq org-export-allow-bind-keywords t)

(provide 'org-mode-settings)
