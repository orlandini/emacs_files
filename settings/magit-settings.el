
(defun dm/change-commit-author (arg)
  "Change the commit author during an interactive rebase in Magit.
With a prefix argument, insert a new change commit author command
even when there is already another rebase command on the current
line.  With empty input, remove the change commit author action
on the current line, if any."
  (interactive "P")
  (let ((author
         (magit-transient-read-person "Select a new author for this commit"
                               nil
                               nil)))
    (git-rebase-set-noncommit-action
     "exec"
     (lambda (_) (if author
                     (format "git commit --amend --author='%s'" author)
                   ""))
     arg)))

(use-package magit
  :defer 0.5
  :init     
    (setq auth-source-debug 'trivia)
  :config
  (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source)
  )

(with-eval-after-load 'magit '(define-key git-rebase-mode-map (kbd "h") #'dm/change-commit-author))

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