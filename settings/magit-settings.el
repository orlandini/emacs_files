
(use-package magit
  :defer t)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c b") 'magit-blame)


(provide 'magit-settings)
