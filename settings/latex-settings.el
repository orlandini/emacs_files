(use-package reftex
  :ensure t
  :after tex
  :hook (LaTeX-mode . reftex-mode)
  :config
  (setq reftex-plug-into-AUCTeX t)
  (reftex-ref-style-activate "Cleveref"))


(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t
        TeX-parse-self t)
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
