;;; autocomplete-settings -- Summary
                                        ;Autocomplete settings for Emacs

;;; Commentary:
                                        ;nothing really
;;; Code:

(use-package projectile
  :ensure t)

(use-package lsp-mode
  :defer t
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "pyls")
                    :major-modes '(python-mode)
                    :server-id 'pyls)
   )
  (setq lsp-file-watch-threshold 3000)
  :commands lsp
  :hook (
         (python-mode . lsp))
  )
  ;; (add-hook 'lsp-mode-hook
;; '(lambda () (local-set-key (kbd "C-.") 'lsp-describe-thing-at-point))))

(use-package lsp-ui
  :defer t
  :commands lsp-ui-mode)
(setq lsp-ui-doc-enable nil)

(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config (push 'company-lsp company-backends)) ;; add company-lsp as a backend

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
