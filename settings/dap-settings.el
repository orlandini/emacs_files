;;; package -- Summary: dap setings for Emacs
;;; Commentary:
; nothing special

;;; Code:

;; =================================
;; DAP configuration
;; =================================


(use-package dap-mode
  :defer
  :custom
  (dap-auto-configure-mode t "Automatically configure dap.")
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  
  :config
  (add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))
  (dap-tooltip-mode t)
  ;; Set up C++ debugging
  (require 'dap-lldb)
  (require 'dap-cpptools)
  (require 'dap-gdb-lldb)
  ;;; set the debugger executable (c++)
  (setq dap-lldb-debug-program '("/usr/bin/lldb-vscode-10"))

  ;;; ask user for executable to debug if not specified explicitly (c++)
  (setq dap-lldb-debugged-program-function (lambda () (read-file-name "Select file to debug.")))
  ;; Set up Python debugging
  (require 'dap-python)
  (setq dap-python-executable "python3")
  (setq dap-python-debugger 'debugpy))

;; (use-package dap-mode
;;   :defer
;;   :custom
;;   (dap-auto-configure-mode t                           "Automatically configure dap.")
;;   (dap-auto-configure-features
;;    '(sessions locals breakpoints expressions tooltip)  "Remove the button panel in the top.")
;;   :config
;;   ;;; dap for c++
;;   (require 'dap-lldb)
;;   ;;; dap for python
;;   (require 'dap-python)
;;   ;;; autoconfig
;;   (require 'dap-cpptools)
;;   ;;; set the debugger executable (c++)
;;   (setq dap-lldb-debug-program '("/usr/bin/lldb-vscode-10"))
;;   (setq dap-python-executable "python3")
;;   (setq dap-python-debugger 'debugpy)

;;   ;;; ask user for executable to debug if not specified explicitly (c++)
;;   (setq dap-lldb-debugged-program-function (lambda () (read-file-name "Select file to debug.")))

;;   (defun dap-debug-create-or-edit-json-template ()
;;     "Edit the C++ debugging configuration or create + edit if none exists yet."
;;     (interactive)
;;     (let ((filename (concat (lsp-workspace-root) "/launch.json"))
;;       (default "~/.emacs.d/default-launch.json"))
;;       (unless (file-exists-p filename)
;;     (copy-file default filename))
;;       (find-file-existing filename))))

(provide 'dap-settings)