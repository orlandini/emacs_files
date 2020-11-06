;;; init.el --- My Emacs settings

;;; Commentary:
;;thanks for everyone that provided such useful .el files

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(setq gc-cons-threshold 52428800);;50MB
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/settings")
(require 'better-defaults)
(require 'general-settings)
(require 'system-cores)
;; (require 'helm-settings)
(require 'python-settings)
(require 'cpp-settings)
(require 'autocomplete-settings)
;; (require 'gdb-settings)
(require 'latex-settings)
(require 'org-mode-settings)
(require 'magit-settings)

;; setting the threshold to call garbage collector to a normal value again
(setq gc-cons-threshold 1048576) ;;1MB


;; ;; End:
;; ;;; init.el ends here


;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(c-noise-macro-names (quote ("constexpr")))
;;  '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
;;  '(org-trello-files (quote ("~/org/trello/ngs.org" "")) nil (org-trello))
;;  '(package-selected-packages
;;    (quote
;;     (auctex crux company-quickhelp shx transient ccls eglot magit-popup gnu-elpa-keyring-update company-lsp cquery lsp-ui lsp-mode vterm use-package smex pdf-tools org-trello nord-theme move-text magit helm flycheck-pos-tip flycheck-color-mode-line elpy ein cmake-mode cff blacken)))
;;  '(python-shell-interpreter "/usr/bin/python3")
;;  '(safe-local-variable-values
;;    (quote
;;     ((TeX-command-extra-options . "-shell-escape")
;;      (TeX-command-extra-optins . "-shell-escape")))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
