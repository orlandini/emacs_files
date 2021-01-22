(use-package reftex
  :defer t
  :config ; TODO how to detect if cleveref is loaded before deciding upon cref?
  (defun reftex-format-cref (label def-fmt ref-style)
    (format "\\cref{%s}" label))
  (setq reftex-format-ref-function 'reftex-format-cref))

(use-package auctex
  :defer t
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        reftex-plug-into-AUCTeX t)
  :hook (LaTeX-mode . reftex-mode))

(provide 'latex-settings)
