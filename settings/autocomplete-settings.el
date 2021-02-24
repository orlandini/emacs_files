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
  :hook (python-mode . (lambda ()
                         (setq lsp-python-ms-extra-paths "/opt/netgen/lib/python3/dist-packages")
                         (require 'lsp-python-ms)
                         (lsp)))
  ;; This hack is necessary to make additional flycheck checkers work in lsp-mode
  ;; taken from: https://github.com/emacs-lsp/lsp-python-ms/issues/43
   (flycheck-mode . (lambda ()
                      (flycheck-add-next-checker 'lsp 'python-flake8)
                      ;; (flycheck-add-next-checker 'python-flake8 'python-mypy)
                      (message "Added flycheck checkers.")))
  )

(use-package lsp-ui
  :defer t
  :commands lsp-ui-mode
  :hook (python-mode . lsp-ui-mode)
  (c++-mode . lsp-ui-mode)
  :config
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-prefer-flymake nil)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-file-watch-threshold 3000)
  )

(use-package flycheck
  :defer t
  :config
  (setq flycheck-python-flake8-executable "flake8"))

(use-package company-lsp
  :defer t
  :commands company-lsp
  :config (push 'company-lsp company-backends)
  (push '((company-capf :with company-yasnippet)) company-backends)

  ) ;; add company-lsp as a backend

(use-package ccls
  :defer t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp)))
  :config
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  )

;; https://github.com/FredeEB/.emacs.d#yasnippet

(use-package yasnippet-snippets
  :defer t)
(use-package react-snippets
  :defer t)

(use-package yasnippet
  :hook (python-mode . yasnippet-mode)
  (c-mode . yasnippet-mode)
  (c++-mode . yasnippet-mode)
  (c-or-c++-mode . yasnippet-mode)
  :defer t)

(use-package auto-yasnippet
  :defer t)

(defun company-yasnippet-or-completion ()
  (interactive)
  (let ((yas-fallback-behavior nil))
    (unless (yas-expand)
      (call-interactively #'company-complete-common))))

(add-hook 'company-mode-hook
	  (lambda () (substitute-key-definition
		      'company-complete-common
		      'company-yasnippet-or-completion
		      company-active-map)))

(provide 'autocomplete-settings)
;;; autocomplete-settings.el ends here
