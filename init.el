;;; init.el --- My Emacs settings

;;; Commentary:
;;thanks for everyone that provided such useful .el files

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(when (version< emacs-version "27")
  (load (concat user-emacs-directory "early-init.el")))


(package-initialize)
(add-to-list 'load-path "~/.emacs.d/settings")
;; (require 'better-defaults)
(require 'general-settings)
(require 'system-cores)
(require 'ivy-settings)
(require 'python-settings)
(require 'cpp-settings)
(require 'gdb-settings)
;; (require  'dap-settings)
;; (require 'autocomplete-settings-new)
(require 'autocomplete-settings)

(require 'latex-settings)
(require 'org-mode-settings)
(require 'magit-settings)

(require 'dwim-settings)
;; ;; End:
;; ;;; init.el ends here
