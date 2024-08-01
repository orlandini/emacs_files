(use-package reftex
  :ensure t
  :after tex
  :hook (LaTeX-mode . reftex-mode)
  :config
  (setq reftex-plug-into-AUCTeX t)
  (reftex-ref-style-activate "Cleveref"))


(use-package tex
  :defer t
  :ensure auctex
  :hook ((LaTeX-mode) . lsp)
  :config
  (setq TeX-auto-save t
        TeX-parse-self t)
  (define-key TeX-mode-map "\"" #'self-insert-command);; avoid annoying quote replacement
  (define-key TeX-mode-map "^" #'self-insert-command);; avoid annoying superscript replacement
  (define-key TeX-mode-map "_" #'self-insert-command);; avoid annoying subscript replacement
  (setq LaTeX-babel-hyphen nil);; avoid annoying hyphen replacement
  :init  ;; to use pdfview with auctex
   (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
         TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
         TeX-source-correlate-start-server t) ;; not sure if last line is neccessary
   (setq TeX-source-correlate-method 'synctex) ; enable synctex
   (setq TeX-source-correlate-mode t) ; enable text-source-correlate using synctex
   ;; to have the buffer refresh after compilation
   (setq lsp-tex-server 'digestif)
   (add-hook 'TeX-after-compilation-finished-functions
             #'TeX-revert-document-buffer))

(use-package bibtex
  :after tex
  :config
  (setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator ""
      bibtex-autokey-year-title-separator "-"
      bibtex-autokey-titleword-separator "-"
      bibtex-autokey-titlewords 2
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5)
  ;; (setq bibtex-completion-bibliography '("~/orgmode/bibliography.bib")
	;; bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"

	;; bibtex-completion-additional-search-fields '(keywords)
	;; bibtex-completion-display-formats
	;; '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	;;   (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	;;   (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	;;   (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	;;   (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
	;; bibtex-completion-pdf-open-function
	;; (lambda (fpath)
	;;   (call-process "open" nil 0 nil fpath)))
  )

(provide 'latex-settings)
