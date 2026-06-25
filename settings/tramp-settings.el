;;; tramp-settings -- Summary
                                        ;tramp settings for Emacs

;;; Commentary:
                                        ;nothing really
;;; Code:
(use-package tramp
  :ensure t
  :config
  (setq tramp-terminal-type "tramp"))

;; correctly finds path on remote matchine
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

;; apparently it helps with lag
(defun my-vc-off-if-remote ()
  (if (file-remote-p (buffer-file-name))
      (setq-local vc-handled-backends '(Git))))
(add-hook 'find-file-hook 'my-vc-off-if-remote)


;; https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
(setq remote-file-name-inhibit-locks t
      tramp-use-scp-direct-remote-copying t
      remote-file-name-inhibit-auto-save-visited t)
(setq tramp-copy-size-limit (* 1024 1024) ;; 1MB
      tramp-verbose 2)

(connection-local-set-profile-variables
 'remote-direct-async-process
 '((tramp-direct-async-process . t)))

(connection-local-set-profiles
 '(:application tramp :protocol "scp")
 'remote-direct-async-process)

(setq magit-tramp-pipe-stty-settings 'pty)
(with-eval-after-load 'tramp
  (with-eval-after-load 'compile
    (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options)))

(provide 'tramp-settings)
;;; tramp-settings.el ends here