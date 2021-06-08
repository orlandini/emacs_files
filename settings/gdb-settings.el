;;; package -- Summary: gdb setings for Emacs
;;; Commentary:
; nothing special

;;; Code:

;; =================================
;; GDB configuration
;; =================================
(use-package gdb-mi
  :after quelpa
  :quelpa (gdb-mi :fetcher git
                  :url "https://github.com/weirdNox/emacs-gdb.git"
                  :files ("*.el" "*.c" "*.h" "Makefile"))
  :init
  (fmakunbound 'gdb)
  (fmakunbound 'gdb-enable-debug)))


(provide 'gdb-settings)
