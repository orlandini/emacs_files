(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

(require 'use-package)

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
  :ensure t
  ;; To use MELPA Stable use ":pin mepla-stable",
  :pin melpa
  :commands (esup))
(setq esup-depth 0)

;; https://github.com/dholm/benchmark-init-el
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))


;; https://www.emacswiki.org/emacs/SavePlace
(save-place-mode 1)

;; http://pragmaticemacs.com/emacs/advanced-undoredo-with-undo-tree/
(use-package undo-tree
  :config
  ;;turn on everywhere
  (global-undo-tree-mode 1)
  ;; make ctrl-z undo
  ;; (global-set-key (kbd "C-z") 'undo)
  ;; ;; make ctrl-Z redo
  ;; (defalias 'redo 'undo-tree-redo)
  ;; (global-set-key (kbd "C-S-z") 'redo)
  :bind (("C-z" . undo)
         ("C-S-z" . 'undo-tree-redo)))

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

;;keys preferences
(defun smart-kill-line-backwards ()
  "Kill line backwards and indent"
  (interactive)
  (kill-line 0)
  (c-indent-line-or-region)
  ;; (delete-indentation)
  )

(global-set-key (kbd "<C-backspace>") 'smart-kill-line-backwards)
;; (global-set-key (kbd "<C-backspace>") 'delete-indentation)


(use-package exec-path-from-shell
  :defer 1
  :config
  
  (setenv "SHELL" "/usr/bin/zsh")
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "PYTHONPATH")
  (exec-path-from-shell-copy-env "DYLD_LIBRARY_PATH")
  (exec-path-from-shell-copy-env "LD_LIBRARY_PATH")
  ;; (if (not (eq system-type 'darwin))
  ;;     (setenv "SHELL" "/usr/bin/zsh")
  ;;   )
  ;; (when (memq window-system '(mac ns x))
  ;;   (exec-path-from-shell-initialize)
  ;;   (exec-path-from-shell-copy-env "PYTHONPATH")
  ;;   (exec-path-from-shell-copy-env "DYLD_LIBRARY_PATH")
  ;;   (exec-path-from-shell-copy-env "LD_LIBRARY_PATH")
  ;;   )
  )


  ;; )
                                        ; (use-package vterm
                                        ;  :ensure t)


;; ansi colors in shell
(use-package ansi-color
  :defer t)

;; (use-package shx
;;   :ensure t
;;   :config
;;   (add-hook 'shx-mode-hook 'ansi-color-for-comint-mode-on))

  
; language
(setq current-language-environment "English")
; don't show the startup screen
(setq inhibit-startup-screen t)

                                        ; always show line numbers
(if (version< emacs-version "26")
    (message "")
  (global-display-line-numbers-mode))



; don't show the menu bar
(menu-bar-mode 0)
; don't show the tool bar
(tool-bar-mode 0)

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
     (add-to-list 'grep-find-ignored-directories ".cquery_cached_index")
     (add-to-list 'grep-find-ignored-directories ".ccls-cache")))

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
 :defer t)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)


(progn
  (defun boundary ()
    (and      (= (char-syntax (char-after))  ?w)
              (not (= (char-syntax (char-before)) ?w))))
  (defun my-forward-word ()
    (interactive) 
    (while (progn (forward-char)  (not (boundary)))))
  (defun my-backward-word ()
    (interactive) 
    (while (progn (backward-char) (not (boundary)))))
  (global-set-key (kbd "M-f") 'my-forward-word)
  (global-set-key (kbd "M-b")  'my-backward-word)
  ;; (global-set-key [M-right] 'my-forward-word)
  ;; (global-set-key [M-left]  'my-backward-word)
  )

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


(setq custom-safe-themes t)
(use-package nord-theme
  :ensure t
  :config
  (load-theme 'nord t)
  (set-face-attribute 'default nil
                      :family "Menlo"
                      ;; :family "Source Code Pro"
                      :height 140
                      :weight 'normal
                      :width 'normal)
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

;; improve long line
;; (set bidi-inhibit-bpa t)
(use-package pdf-tools
  :defer t
  :config
  (pdf-loader-install :no-query))

(provide 'general-settings)
