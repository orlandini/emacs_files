
;; Text mode is initial mode
(setq initial-major-mode 'text-mode)

;; Text mode is default major mode
(setq default-major-mode 'text-mode)
;; (let ((custom--inhibit-theme-enable nil))
;;   (use-package nano-theme
;;     :quelpa (nano-theme
;;              :fetcher github
;;              :repo "rouogier/nano-theme")
;;     :init
;;     (load-theme 'nano t)
;;     :config
;;     (nano-mode)
;;     (nano-dark))
;;   )

(use-package nano-theme
  :ensure nil
  :defer t
  :quelpa (nano-theme
           :fetcher github
           :repo "rougier/nano-theme")
  :init
  (load-theme 'nano t))

;; (nano-mode)
;; (nano-dark)
(use-package nano-modeline
  :config
  (add-hook 'prog-mode-hook            #'nano-modeline-prog-mode)
  (add-hook 'text-mode-hook            #'nano-modeline-text-mode)
  (add-hook 'org-mode-hook             #'nano-modeline-org-mode)
  (add-hook 'pdf-view-mode-hook        #'nano-modeline-pdf-mode)
  (add-hook 'mu4e-headers-mode-hook    #'nano-modeline-mu4e-headers-mode)
  (add-hook 'mu4e-view-mode-hook       #'nano-modeline-mu4e-message-mode)
  (add-hook 'elfeed-show-mode-hook     #'nano-modeline-elfeed-entry-mode)
  (add-hook 'elfeed-search-mode-hook   #'nano-modeline-elfeed-search-mode)
  (add-hook 'term-mode-hook            #'nano-modeline-term-mode)
  (add-hook 'xwidget-webkit-mode-hook  #'nano-modeline-xwidget-mode)
  (add-hook 'messages-buffer-mode-hook #'nano-modeline-message-mode)
  (add-hook 'org-capture-mode-hook     #'nano-modeline-org-capture-mode)
  (add-hook 'org-agenda-mode-hook      #'nano-modeline-org-agenda-mode)
  (nano-modeline-text-mode t)
  )

(eval-after-load "org-mode"
  '(progn
     (set-face-foreground 'org-done nano-dark-popout)
     (set-face-foreground 'org-todo nano-dark-critical)
     (set-face-foreground 'org-level-2 nano-dark-salient)))

(defun load-nano-dark-theme (_frame)
  (nano-mode)
  (nano-dark))
(run-at-time "0.2" nil (lambda nil (nano-dark)))
(add-hook 'after-make-frame-functions #'load-nano-dark-theme)
;; Immediate border toggling (using default header)
(require 'buffer-box)
(provide 'theme-settings)