;;; autocomplete-settings -- Summary
                                        ;Autocomplete settings for Emacs

;;; Commentary:
                                        ;nothing really
;;; Code:
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-prefer-flymake nil)
  (setq lsp-file-watch-threshold 3000)
  (setq lsp-completion-no-cache t)
  (lsp-enable-which-key-integration t)
  
  (advice-add #'lsp--auto-configure :override #'ignore)
  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-delay 1)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :demand t
  :after lsp)

(use-package company
  :demand t
  :after lsp-mode
  :init (global-company-mode 1)
  :hook (lsp-mode . company-mode)
  ;; :custom
  ;; (company-minimum-prefix-length 1)
  ;; (company-idle-delay 0.5)
  )

(use-package  company-box
  :demand t
  :after company
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-x p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/git")
    (setq projectile-project-search-path '("~/git")))
  (setq projectile-switch-project-action #'projectile-dired))


(use-package flycheck
  :demand t
  :after lsp
  :config
  (setq-default flycheck-python-pyright-executable "/usr/local/bin/pyright")
  (setq-default flycheck-python-flake8-executable "/usr/local/bin/flake8"))

(use-package flycheck-pos-tip
  :demand t
  :after flycheck)

(use-package ccls
  :defer t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp)))
  :config
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  )

;;workaround for ccls bug
(advice-add 'json-parse-string :around 
            (lambda (orig string &rest rest)
              (apply orig (s-replace "\\u0000" "" string)
                     rest)))

(use-package lsp-pyright
  :defer t
  :hook ((python-mode) . (lambda () (require 'lsp-pyright) (lsp)))
  :if (executable-find "pyright")
  :config
  (setq lsp-pyright-python-executable "/usr/bin/python3")
  (setq lsp-pyright-python-executable-cmd "python3")
  (setq lsp-pyright-stub-path "")
  (setq lsp-pyright-use-library-code-for-types nil)
  (setq lsp-pyright-auto-import-completions t)
  (setq lsp-pyright-auto-search-paths t)
  )

;; https://github.com/FredeEB/.emacs.d#yasnippet
(use-package yasnippet
  :config
  (yas-global-mode 1)
  (setq yas-triggers-in-field t)
  )

(use-package yasnippet-snippets
  :after yasnippet
  :config
  (add-hook 'python-mode-hook
      (lambda ()
        (make-local-variable 'yas-snippet-dirs)
        (setq yas-snippet-dirs "~/.emacs.d/snippets")))
  )

;; (use-package auto-yasnippet
;;   :after yasnippet)

;; might be useful
;; (defun company-yasnippet-or-completion ()
;;   (interactive)
;;   (let ((yas-fallback-behavior nil))
;;     (unless (yas-expand)
;;       (call-interactively #'company-complete-common))))

;; (add-hook 'company-mode-hook
;; 	  (lambda () (substitute-key-definition
;; 		      'company-complete-common
;; 		      'company-yasnippet-or-completion
;; 		      company-active-map)))

(provide 'autocomplete-settings)
;;; autocomplete-settings.el ends here
