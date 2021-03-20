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
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-delay 1)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1))

(use-package  company-box
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/git")
    (setq projectile-project-search-path '("~/git")))
  (setq projectile-switch-project-action #'projectile-dired))


(use-package flycheck
  :defer t
  :config
  (setq flycheck-python-flake8-executable "flake8"))



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
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  :if (executable-find "pyright")
  :config
  (setq lsp-pyright-python-executable "/usr/local/bin/python3")
  (setq lsp-pyright-python-executable-cmd "python3")
  (setq lsp-pyright-stub-path "")
  (setq lsp-pyright-use-library-code-for-types t)
  (setq lsp-pyright-auto-import-completions t)
  (setq lsp-pyright-auto-search-paths t)
  ;; ;; This hack is necessary to make additional flycheck checkers work in lsp-mode
  ;; ;; taken from: https://github.com/emacs-lsp/lsp-python-ms/issues/43
  ;; (flycheck-mode . (lambda ()
  ;;                    (flycheck-add-next-checker 'lsp 'python-flake8)
  ;;                    ;; (flycheck-add-next-checker 'python-flake8 'python-mypy)
  ;;                    (message "Added flycheck checkers.")))
  )

;; https://github.com/FredeEB/.emacs.d#yasnippet
(use-package yasnippet
  :defer t
  :hook (python-mode . yas-minor-mode)
  (c-mode . yas-minor-mode)
  (c++-mode . yas-minor-mode)
  (c-or-c++-mode . yas-minor-mode))

(use-package yasnippet-snippets
  :after yasnippet
  :defer t)

(use-package react-snippets
  :after yasnippet
  :defer t)

(use-package auto-yasnippet
  :after yasnippet
  :defer t)



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
