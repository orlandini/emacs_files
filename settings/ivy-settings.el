;; taken from here https://ogbe.net/emacs/minimal.html
(use-package ivy
  :ensure t
  :demand
  :diminish ivy-mode
  :bind (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window)
   ("C-x b" . ivy-switch-buffer))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  (ivy-use-selectable-prompt t)
  ;; :hook
  ;; (ivy-mode . ivy-posframe-mode) ;; see the posframe block below
  :config
  (ivy-mode)
  (setq enable-recursive-minibuffers t)

  ;;https://emacs.stackexchange.com/questions/36745/enable-ivy-fuzzy-matching-everywhere-except-in-swiper
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (swiper-backward . ivy--regex-plus)
          (t      . ivy--regex-fuzzy)))
  )

;; IMPORTANT: ivy-toggle-regexp-quote (M-r) is your friend for temporarily disabling regexp ;)

(use-package counsel
  :after ivy
  :ensure t
  :demand
  :diminish counsel-mode
  :config
  (counsel-mode 1))

(provide 'ivy-settings)