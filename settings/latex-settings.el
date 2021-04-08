(use-package reftex
  :hook latex-mode
  :config ; TODO how to detect if cleveref is loaded before deciding upon cref?
  (defun reftex-format-cref (label def-fmt ref-style)
    (format "\\cref{%s}" label))
  (setq reftex-format-ref-function 'reftex-format-cref))

(use-package auctex
  :hook latex-mode
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        reftex-plug-into-AUCTeX t)
  :hook (LaTeX-mode . reftex-mode)
  :init  ;; to use pdfview with auctex
   (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
         TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
         TeX-source-correlate-start-server t) ;; not sure if last line is neccessary
   (setq TeX-source-correlate-method 'synctex) ; enable synctex
   (setq TeX-source-correlate-mode t) ; enable text-source-correlate using synctex
   ;; to have the buffer refresh after compilation
   (add-hook 'TeX-after-compilation-finished-functions
             #'TeX-revert-document-buffer))

(provide 'latex-settings)
