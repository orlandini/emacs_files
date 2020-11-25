;;; init.el --- My Emacs settings

;;; Commentary:
;;thanks for everyone that provided such useful .el files

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.



;;GARBAGE-COLLECTOR SETTINGS
;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
;; and
;; https://github.com/hlissner/doom-emacs/blob/develop/docs/faq.org#how-does-doom-start-up-so-quickly

(defun custom-defer-garbage-collection-h ()
  (setq gc-cons-threshold most-positive-fixnum
        gc-cons-percentage 0.6))

(defun custom-restore-garbage-collection-h ()
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold 16777216 ; 16mb
                          gc-cons-percentage 0.1))))

;; setting different gc values for startup
(custom-defer-garbage-collection-h)
(add-hook 'emacs-startup-hook #'custom-restore-garbage-collection-h)
;; raising gc-cons-threshold when minibuffer is active
(add-hook 'minibuffer-setup-hook #'custom-defer-garbage-collection-h)
(add-hook 'minibuffer-exit-hook #'custom-restore-garbage-collection-h)

(package-initialize)
(add-to-list 'load-path "~/.emacs.d/settings")
;; (require 'better-defaults)
(require 'general-settings)
(require 'system-cores)

(require 'python-settings)
(require 'cpp-settings)
(require 'autocomplete-settings)

(require 'latex-settings)
(require 'org-mode-settings)
(require 'magit-settings)


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
