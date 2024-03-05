;;; python-settings --- Summary
;;; Commentary:
                                        ; My settings for python in Emacs
;;; Code:
(if (eq system-type 'darwin)
    (setq python-path "/usr/local/bin/python3")
  (setq python-path "/usr/bin/python3")
  )
(setq python-shell-interpreter "ipython3")
(setq python-shell-interpreter-args "--simple-prompt --pprint")


;;this will set the WORKING DIRECTORY of python interpreter as project root
(defun my-run-python ()
  (interactive)
  (let ((default-directory (or (projectile-project-root) default-directory)))
    (call-interactively #'run-python)))

(use-package py-autopep8
  :ensure t
  :demand t
  :after lsp-pyright
  :hook (python-mode . py-autopep8-mode)
  :config (setq py-autopep8-options '("--max-line-length=80" "--experimental")))

(use-package numpydoc
  :ensure t
  :defer t
  :bind (:map python-mode-map
              ("C-c C-n" . numpydoc-generate)))

(use-package ein
  :ensure t
  :defer t)

(provide 'python-settings)
;;; python-settings.el ends here