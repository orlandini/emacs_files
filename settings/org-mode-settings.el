(use-package org
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

(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode)
  :config
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.75))
  )
;; ORG-AGENDA settings
;; references:
;;    http://www.personal.psu.edu/bam49/notebook/org-mode-for-research/
(setq org-agenda-files
      (file-expand-wildcards "~/orgmode/*.org"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "SOMEDAY(s)" "PROJ(p)" "|" "DONE(d)" "CANCELLED(c)")))

(setq org-export-allow-bind-keywords t)


(use-package org-pomodoro
  :hook org-mode
  :config
  (setq org-pomodoro-keep-killed-pomodoro-time t)
  )

;; sync google agenda

;; (use-package org-gcal
;; :hook org-mode
;; :config
;; (setq org-gcal-client-id "<my-client-id>"
;; org-gcal-client-secret "<my-client-secret>"
;; org-gcal-file-alist '(("<my-email>" .  "~/orgmode/gcal-main.org")
;;                       ("uoklg77oj06cob1gaan5tnjr6o@group.calendar.google.com" . "~/orgmode/gcal-labmec.org")
;;                       ("171qvqt3f7g4aim0t1njl0vf98@group.calendar.google.com" .  "~/orgmode/gcal-unicamp.org")
;;                       ("ehua3rb4s12op0155ktir43fb4@group.calendar.google.com" .  "~/orgmode/gcal-health.org")))
;; )

(provide 'org-mode-settings)
