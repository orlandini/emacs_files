;;; autocomplete-settings -- Summary
                                        ;Autocomplete settings for Emacs

;;; Commentary:
                                        ;nothing really
;;; Code:


;;https://github.com/blahgeek/emacs-lsp-booster
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))) ;; Configure orderless
  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  ((c-mode c++-mode objc-mode cuda-mode f90-mode) .
   (lambda ()  (lsp)))
  :custom
  (lsp-completion-provider :none) ;; we use Corfu!
  :config
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-disabled-clients '(clangd))
  (setq lsp-prefer-flymake nil)
  (setq lsp-file-watch-threshold 500)
  (setq lsp-completion-no-cache t)
  (setq lsp-keep-workspace-alive nil)
  (setq lsp-idle-delay 0.500)
  (setq lsp-enable-suggest-server-download nil)
  (setq lsp-clients-fortls-args '("--enable_code_actions" "--hover_signature"))
  (lsp-enable-which-key-integration t)
  (add-to-list 'lsp-file-watch-ignored "build")
  (add-to-list 'lsp-file-watch-ignored ".cache")
  
  (advice-add #'lsp--auto-configure :override #'ignore)
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-delay 1)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :demand t
  :after lsp)


(use-package lsp-latex
  :after lsp
  ;; this uses texlab
  :ensure t
  :config
  (progn
    (add-hook 'bibtex-mode-hook 'lsp-deferred)
    )
  )

(defun corfu-enable-always-in-minibuffer ()
  "Enable Corfu in the minibuffer if Vertico/Mct are not active."
  (unless (or (bound-and-true-p mct--active)
              (bound-and-true-p vertico--input)
              (eq (current-local-map) read-passwd-map))
    ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
    (setq-local corfu-popupinfo-delay 0.0001)
    (corfu-mode 1)))

(use-package corfu
  :demand t
  :after orderless
  :custom
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match t)
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-preselect-first nil)    ;; Disable candidate preselection
  (corfu-popupinfo-delay 0.0001)
  :hook
  ((corfu-mode . corfu-popupinfo-mode))
  :config
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer)
  :init
  (global-corfu-mode))

(use-package cape
  :ensure t)
(use-package orderless
  :demand t
  :init
  (setq completion-styles '(orderless partial-completion basic)
        completion-category-defaults nil
        completion-category-overrides nil)
  :config
  ;; Fix completing hostnames when using /ssh:
  (setq completion-styles '(orderless)
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-x p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/git")
    (setq projectile-project-search-path '("~/git")))
  (setq projectile-switch-project-action #'projectile-dired))


(use-package flycheck
  :demand t
  :after lsp
  :config
  (setq-default flycheck-python-pyright-executable "/usr/local/bin/pyright")
  (setq-default flycheck-python-flake8-executable "/usr/local/bin/flake8"))

(use-package flycheck-pos-tip
  :demand t
  :after flycheck)

(use-package ccls
  :defer t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp-deferred)))
  :config
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  )

;;workaround for ccls bug
(advice-add 'json-parse-string :around 
            (lambda (orig string &rest rest)
              (apply orig (s-replace "\\u0000" "" string)
                     rest)))

(use-package lsp-pyright
  :defer t
  :custom (lsp-pyright-langserver-command "basedpyright")
  :hook ((python-mode . (lambda () (require 'lsp-pyright)))
	   (python-mode . lsp-deferred))
  :config
  ;; these hooks can't go in the :hook section since lsp-restart-workspace
  ;; is not available if lsp isn't active
  (add-hook 'conda-postactivate-hook (lambda () (lsp-restart-workspace)))
  (add-hook 'conda-postdeactivate-hook (lambda () (lsp-restart-workspace)))
  ;; (setq lsp-pyright-python-executable "/usr/bin/python3")
  ;; (setq lsp-pyright-python-executable-cmd "python3")
  ;; (setq lsp-pyright-stub-path "")
  ;; (setq lsp-pyright-use-library-code-for-types nil)
  ;; (setq lsp-pyright-auto-import-completions t)
  ;; (setq lsp-pyright-auto-search-paths t)
  ;; (setq lsp-pyright-extra-paths '(projectile-project-root))
  )


(defvar-local my/flycheck-local-cache nil)

(defun my/flycheck-checker-get (fn checker property)
  (or (alist-get property (alist-get checker my/flycheck-local-cache))
      (funcall fn checker property))) 

(advice-add 'flycheck-checker-get :around 'my/flycheck-checker-get)

(add-hook 'lsp-managed-mode-hook
          (lambda ()
            (when (derived-mode-p 'tex-mode)
              (flycheck-add-mode 'proselint 'latex-mode)
              (setq my/flycheck-local-cache '((lsp . ((next-checkers . (proselint)))))))))

;; https://github.com/FredeEB/.emacs.d#yasnippet
(use-package yasnippet
  :config
  (yas-global-mode 1)
  (setq yas-triggers-in-field t)
  )

(use-package yasnippet-snippets
  :after yasnippet
  :config
  (add-hook 'python-mode-hook
      (lambda ()
        (make-local-variable 'yas-snippet-dirs)
        (setq yas-snippet-dirs "~/.emacs.d/snippets")))
  )

;; (use-package auto-yasnippet
;;   :after yasnippet)

;; might be useful
;; (defun company-yasnippet-or-completion ()
;;   (interactive)
;;   (let ((yas-fallback-behavior nil))
;;     (unless (yas-expand)
;;       (call-interactively #'company-complete-common))))

;; (add-hook 'company-mode-hook
;; 	  (lambda () (substitute-key-definition
;; 		      'company-complete-common
;; 		      'company-yasnippet-or-completion
;; 		      company-active-map)))

(provide 'autocomplete-settings)
;;; autocomplete-settings.el ends here
