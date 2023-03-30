
(use-package magit
  :defer 0.5
  :init     
    (setq auth-source-debug 'trivia)
  :config
    (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source))


(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c b") 'magit-blame)


(use-package ghub
  :demand t
  :after magit)

;; (use-package forge
;;   :demand t
;;   :after ghub)

(setq auth-sources '("~/.authinfo.gpg"))

(provide 'magit-settings)
;; 