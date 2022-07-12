;;; package -- Summary: cpp setings for Emacs
;;; Commentary:
; nothing special

;;; Code:


(setq-default cmake-tab-width my-tab-width)

(use-package cc-mode
  :hook c++-mode
  :init
  (fset 'add_block_brackets
        [return ?\{ return return ?\} up tab])
  :bind (:map c-mode-base-map
              ("C-{" . 'add_block_brackets))
  :hook
  ;; https://stackoverflow.com/questions/1475279/how-to-control-indentation-after-an-open-parenthesis-in-emacs
  ((c-mode c++-mode objc-mode cuda-mode) . (lambda () (c-set-offset 'arglist-intro 'my-tab-width)))
  ((c-mode c++-mode objc-mode cuda-mode) . (lambda () (c-set-offset 'substatement-open 0)))
  :config
  (setq-default c-basic-offset my-tab-width)
  )

(use-package cmake-mode
  :demand t
  :after cc-mode)

(defun demangle-at-point ()
  (interactive)
   (message (shell-command-to-string (concat "c++filt _" (thing-at-point 'word))))
   )

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(use-package cff
  :demand t
  :after cc-mode
  :hook
  ((c-mode c++-mode objc-mode cuda-mode) . (lambda () (define-key c-mode-base-map (kbd "M-o") 'cff-find-other-file))))

(defun my-next-error ()
  "Jump to next error - not warning"
  (interactive)
  (compilation-set-skip-threshold 2)
  (compilation-next-error 1)
  (compilation-set-skip-threshold 1))

(defun my-previous-error ()
  "Jump to next error - not warning"
  (interactive)
  (compilation-set-skip-threshold 2)
  (compilation-next-error -1)
  (compilation-set-skip-threshold 1))


;; (use-package compile
;;   :bind (:map compilation-mode-map
;;               ("C-x M-n" . 'my-next-error)
;;               ("C-x M-p" . 'my-previous-error)))

;; (custom-set-variables '(c-noise-macro-names '("constexpr")))

(provide 'cpp-settings)
;;; cpp-settings.el ends here
