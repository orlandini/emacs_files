;;; package -- Summary: dap setings for Emacs
;;; Commentary:
; nothing special

;;; Code:

;; =================================
;; DAP configuration
;; =================================


(use-package dap-mode
  :defer 20
  :custom
  (dap-auto-configure-mode t "Automatically configure dap.")
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)

  :bind
  ("C-x a b" . dap-breakpoint-toggle)
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
  (setq dap-python-debugger 'debugpy)
  (dap-register-debug-template
  "Python :: Run file (buffer)"
  (list :type "python"
        :args ""
        :cwd nil
        :module nil
        :program nil
        :request "launch"
        :justMyCode :json-false
        :name "Python :: Run file (buffer)"))
  )

(provide 'dap-settings)