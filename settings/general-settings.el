(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

(when (not (package-installed-p 'use-package)) (package-refresh-contents) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(setq delete-by-moving-to-trash t)
;;PERFORMANCE
;; https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq read-process-output-max (* 1024 1024)) ;; 1mb
;; https://github.com/stsquad/my-emacs-stuff/blob/33d4dee59a404eba0f236bbadbc8bb4e21095577/my-devel.el#L28 speed up compilation mode
(setq compilation-error-regexp-alist '(gcc-include gnu))
;; Avoid performance issues in files with very long lines.
(global-so-long-mode 1)
;; DEBUGGING INIT TIMES


;; https://blog.d46.us/advanced-emacs-startup/
;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; https://github.com/jschaf/esup
(use-package esup
  :defer 1
  ;; To use MELPA Stable use ":pin mepla-stable",
  :pin melpa
  :commands (esup)
  :config
  (setq esup-depth 1)
  (setq esup-user-init-file (file-truename "~/git/emacs_files/init.el")))


(use-package casual
  :ensure t
  :bind (:map dired-mode-map ("C-o" . casual-dired-tmenu)))

(use-package restart-emacs
  :defer 1)
;; BETTER DEFAULTS
(unless (or (fboundp 'helm-mode) (fboundp 'ivy-mode))
    (ido-mode t)
    (setq ido-enable-flex-matching t))
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-z") 'zap-up-to-char)
(use-package uniquify-files
    :defer 2
    :config
    (setq uniquify-buffer-name-style 'forward)
    )
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
;; https://www.emacswiki.org/emacs/SavePlace
(save-place-mode 1)
(setq column-number-mode t)

(use-package emacs-everywhere
  :config
  (setq emacs-everywhere-paste-p t))

(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 1))

(use-package good-scroll
  :defer 0.5
  :config
  (good-scroll-mode 1))

(use-package multiple-cursors
  :defer 5
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  )

;; ;; http://pragmaticemacs.com/emacs/advanced-undoredo-with-undo-tree/
;; (use-package undo-tree
;;   :defer 6
;;   :config
;;   ;;turn on everywhere
;;   (global-undo-tree-mode)
;;   ;;https://stackoverflow.com/questions/12730158/emacs-cleaning-up-undo-tree
;;   (defun clear-undo-tree () 
;;     (interactive)
;;     (setq buffer-undo-tree nil))
;;   (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
;;   :bind (("C-z" . undo)
;;          ("C-S-z" . undo-tree-redo)
;;          ("C-c u" . clear-undo-tree)
;;          ))

(use-package vundo
    :bind (("C-z" . undo)))
;;smarter-beginning-of-line
;;https://emacsredux.com/blog/2013/05/22/smarter-navigation-to-the-beginning-of-a-line
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)
;;tab-width
(setq my-tab-width 2)
(setq-default tab-width my-tab-width)
;;don't add newlines at the end of the file
(setq mode-require-final-newline nil)
(setq require-final-newline nil) 

(use-package dtrt-indent
  :defer 0.75
  :config
  (dtrt-indent-global-mode 1))

;;keys preferences
(defun smart-kill-line-backwards ()
  "Kill line backwards and indent"
  (interactive)
  (kill-line 0)
  (indent-for-tab-command)
  ;; (delete-indentation)
  )
(setq split-width-threshold 100)
(global-set-key (kbd "<C-backspace>") 'smart-kill-line-backwards)
;; (global-set-key (kbd "<C-backspace>") 'delete-indentation)


(use-package exec-path-from-shell
  :defer 1
  :init
  (setq
   exec-path-from-shell-variables '("PATH" "MANPATH" "PYTHONPATH" "DYLD_LIBRARY_PATH" "LD_LIBRARY_PATH"  "LSP_USE_PLISTS"))
  (setq exec-path-from-shell-arguments nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    )
  )


  ;; )


;; ansi colors in shell
(use-package ansi-color
  :ensure t
  :hook (compilation-filter . ansi-color-compilation-filter) 
  :defer 0.5)

;; (use-package shx
;;   :ensure t
;;   :config
;;   (add-hook 'shx-mode-hook 'ansi-color-for-comint-mode-on))

;; y/n for  answering yes/no questions
(fset 'yes-or-no-p 'y-or-n-p)  
; language
(setq current-language-environment "English")
; don't show the startup screen
(setq inhibit-startup-screen t)

(set-face-attribute 'default nil :family "Hack")

                                        ; always show line numbers
(if (version< emacs-version "26")
    (message "")
  (global-display-line-numbers-mode))


(defun my-inhibit-global-display-line-numbers-mode ()
  "Counter-act `global-display-line-numbers-mode'."
  (add-hook 'after-change-major-mode-hook
            (lambda () (display-line-numbers-mode 0))
            :append :local))

(add-hook 'pdf-view-mode-hook 'my-inhibit-global-display-line-numbers-mode)
(add-hook 'image-mode-hook 'my-inhibit-global-display-line-numbers-mode)

; don't indent with tabs
(setq-default indent-tabs-mode nil)

; do not ignore case when searching
(setq-default case-fold-search nil)

; don't blink the cursor
(blink-cursor-mode 0)

; auto revert buffers
(auto-revert-mode)


;; avoid searching in .cquery_cached_index
(eval-after-load "grep"
  '(progn
    ;; (add-to-list 'grep-find-ignored-files "*.tmp")
     (add-to-list 'grep-find-ignored-directories ".ccls-cache")
     (add-to-list 'grep-find-ignored-directories "build/docs/doxygen")))

; disable backup
(setq backup-inhibited t)
; disable auto save
(setq auto-save-default nil)

; highlight parentheses when the cursor is next to them
(use-package paren
  :defer t
  :config
  (show-paren-mode 1))
;; FRANCISCO
;; (defun build (prog)
;;   (interactive
;;    (list (completing-read "Source: " (directory-files "~/git/source"))))
;;   (if (string= prog "netgen") (compile (format "make -j -C ~/git/build/ngsolve/netgen install"))
;;     (if (file-exists-p (format "~/git/source/%s/setup.py" prog))
;;         (async-shell-command (format "python3 -m pip install --no-deps --user ~/git/source/%s" prog))
;;       (compile (format "make -j -C ~/git/build/%s install" prog)))))
;;
;; ;; window deciation
;; ;; press [pause]
;; (defadvice pop-to-buffer (before cancel-other-window first)
;;   (ad-set-arg 1 nil))
;;
;; ;;(ad-activate 'pop-to-buffer)
;;
;; ;; Toggle window dedication
;; (defun toggle-window-dedicated ()
;;   "Toggle whether the current active window is dedicated or not"
;;   (interactive)
;;   (message
;;    (if (let (window (get-buffer-window (current-buffer)))
;;          (set-window-dedicated-p window
;;                                  (not (window-dedicated-p window))))
;;        "Window '%s' is dedicated"
;;      "Window '%s' is normal")
;;    (current-buffer)))
;;
;; ;; Press [pause] key in each window you want to "freeze"
;; (global-set-key [pause] 'toggle-window-dedicated)




;; rgrep search in header files as well
(eval-after-load "grep" '(setf (cdr (assoc "cc" grep-files-aliases)) (cdr (assoc "cchh" grep-files-aliases))))

(put 'narrow-to-region 'disabled nil)

(use-package move-text
  :defer 0.2
  :config
(global-set-key (kbd "M-P") 'move-text-up)
(global-set-key (kbd "M-N") 'move-text-down)
)

; navigate forward-up-list (based on backward-up-list)
(global-set-key (kbd "C-M-i") (lambda () (interactive) (backward-up-list -1)))


(delete-selection-mode 1)

; window modifications
(global-set-key (kbd "C-s-h") 'shrink-window-horizontally)
(global-set-key (kbd "C-s-l") 'enlarge-window-horizontally)
(global-set-key (kbd "C-s-k") 'shrink-window)
(global-set-key (kbd "C-s-j") 'enlarge-window)

;; remove ^M line endings
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings"
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))


;; (let ((custom--inhibit-theme-enable nil))
;;   (use-package nord-theme
;;     ;; :init
;;     ;; (setq frame-inhibit-implied-resize t)
;;     ;; :config
;;     ;; (setq frame-inhibit-implied-resize nil)
;;     ))


(when (display-graphic-p)
    (use-package nord-theme
  :init
  (load-theme 'nord t)))


(use-package sudo-edit
  :ensure t
  :defer 2
  :config
  (global-set-key (kbd "C-c C-r") 'sudo-edit)
  )

(use-package smex
  :ensure t
  :config
  (smex-initialize)
  
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
  )


;;for using emacsclient in ansi-term
(use-package server
  :defer t
  :config
  (unless (server-running-p) (server-start)))



;;ansi-term won't break ling lines in weird ways
(setq term-suppress-hard-newline t)



;; (use-package quelpa
;;   :defer 3  
;;   :config
;;   (quelpa
;;    '(quelpa-use-package
;;      :fetcher git
;;      :url "https://github.com/quelpa/quelpa-use-package.git"))
;;   (require 'quelpa-use-package))

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
;; the following is for using smudge package for
;; controlling spotify from within emacs
;; (use-package smudge
;;   :config
;;   (setq smudge-oauth2-client-secret "<spotify-app-client-secret>")
;;   (setq smudge-oauth2-client-id "<spotify-app-client-id>")
;;   (setq smudge-status-location 'title-bar)
;;   (define-key smudge-mode-map (kbd "C-c s") 'smudge-command-map)
;;   (global-smudge-remote-mode 1)
;;   (setq smudge-transport 'connect)
;;   :bind (:map smudge-command-map
;;          ("s" . 'smudge-track-search))
;;   )

(use-package shell-pop
  :defer 1
  :init
  (setq shell-pop-universal-key "C-t")
  (setq shell-pop-window-position "bottom")
  (setq shell-pop-restore-window-configuration t)
  (setq shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
  )
;; improve long line
;; (set bidi-inhibit-bpa t)


(use-package pdf-tools
  :ensure t
  :pin manual ;; don't reinstall when package updates
  :mode  ("\\.pdf\\'" . pdf-view-mode)
  :config
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-annot-activate-created-annotations t)
  (pdf-tools-install :no-query)
  (require 'pdf-occur))


(use-package jinx
  :ensure t
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))


(provide 'general-settings)
