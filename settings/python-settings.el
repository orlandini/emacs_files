;;; python-settings --- Summary
;;; Commentary:
                                        ; My settings for python in Emacs
;;; Code:
(if (eq system-type 'darwin)
    (setq python-path "/usr/local/bin/python3")
  (setq python-path "/usr/bin/python3")
  )

;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable)
;;   :config;
;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;   (setq elpy-rpc-virtualenv-path 'current)
;;   (setq python-shell-interpreter python-path)
;;   (setq elpy-rpc-python-command python-path))
;; (use-package blacken
;;   :ensure t
;;   )

;; (use-package ein
;;   :ensure t
;;   )
;; ;; for elpy
;; (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
;; (setq elpy-shell-use-project-root nil)
;; (setq elpy-shell-starting-directory 'current-directory)
(provide 'python-settings)
;;; python-settings.el ends here
