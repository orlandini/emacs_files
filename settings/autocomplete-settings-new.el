;;; autocomplete-settings-new -- Summary
                                        ;Autocomplete settings for Emacs

;;; Commentary:
                                        ;nothing really
;;; Code:
(use-package posframe
  :demand t)
(use-package yasnippet
  :demand t)

(add-to-list 'load-path "~/.emacs.d/lsp-bridge")

(unless (display-graphic-p)
  (add-to-list 'load-path "~/.emacs.d/acm-terminal")
  (with-eval-after-load 'acm
    (require 'acm-terminal)))

(require 'yasnippet)
(yas-global-mode 1)
(require 'lsp-bridge)
(global-lsp-bridge-mode)
(setq lsp-bridge-c-lsp-server 'ccls)

(use-package lsp-mode
  :disabled t)

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
(provide 'autocomplete-settings-new)
;;; autocomplete-settings-new.el ends here
