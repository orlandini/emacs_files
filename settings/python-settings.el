;;; python-settings --- Summary
;;; Commentary:
                                        ; My settings for python in Emacs
;;; Code:
(if (eq system-type 'darwin)
    (setq python-path "/usr/local/bin/python3")
  (setq python-path "/usr/bin/python3")
  )
(setq python-shell-interpreter python-path)

(use-package py-autopep8
  :demand t
  :after lsp-pyright
  :hook (python-mode . py-autopep8-enable-on-save)
  :config (setq py-autopep8-options '("--max-line-length=80" "--experimental")))

(use-package numpydoc
  :ensure t
  :defer t
  :bind (:map python-mode-map
              ("C-c C-n" . numpydoc-generate)))


(provide 'python-settings)
;;; python-settings.el ends here