
(use-package magit
  :defer 2)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c b") 'magit-blame)

(use-package forge
  :after magit)

(setq auth-sources '("~/.authinfo"))

(provide 'magit-settings)
