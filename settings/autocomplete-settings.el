;;; autocomplete-settings -- Summary
                                        ;Autocomplete settings for Emacs

;;; Commentary:
                                        ;nothing really
;;; Code:

(use-package projectile
  :ensure t)

;; already takes care of lsp mode
(use-package lsp-python-ms
  :defer t
  
  :init (setq lsp-python-ms-auto-install-server t)
  :config
  (setq lsp-python-ms-python-executable "/usr/local/bin/python3")
  (setq lsp-python-ms-python-executable-cmd "python3")
  (setq lsp-file-watch-threshold 3000)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp))))  ; or lsp-deferred
  ;; (add-hook 'lsp-mode-hook
;; '(lambda () (local-set-key (kbd "C-.") 'lsp-describe-thing-at-point))))

(use-package lsp-ui
  :defer t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil)
  )

(use-package flycheck
  :defer t)

(use-package company-lsp
  :defer t
  :commands company-lsp
  :config (push 'company-lsp company-backends)
  ) ;; add company-lsp as a backend

(use-package ccls
  :defer t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp)))
  :config
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  )



(use-package yasnippet
  :defer t
  :hook
  ((c-mode c++-mode objc-mode cuda-mode python-mode) . 'yas-minor-mode))

(provide 'autocomplete-settings)
;;; autocomplete-settings.el ends here
