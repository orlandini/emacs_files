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
  (fmakunbound 'gdb-enable-debug)
  :config
  (setq gdb-window-setup-function
        (lambda (session)
          (with-selected-frame (gdb--session-frame session)
            (delete-other-windows)
            (let*
                ((top-left (selected-window))
                 (right (split-window-horizontally
                         (floor (* 0.6 (window-width)))))
                 (bottom-left (split-window-vertically
                              (floor (* 0.9 (window-body-height)))))
                 )
              (select-window right)
              (let*
                  ((top-right (selected-window))
                   (bottom-right (split-window-vertically
                                    (floor (* 0.75(window-body-height)))))
                   (middle-l-right (split-window-vertically
                                  (floor (* 0.666 (window-body-height)))))
                   (middle-u-right (split-window-vertically
                                 (floor (* 0.5 (window-body-height)))))
                   )
                (gdb--set-window-buffer top-left     (gdb--inferior-io-get-buffer session))
                (gdb--set-window-buffer bottom-left    (gdb--comint-get-buffer session))
                (gdb--set-window-buffer top-right  (gdb--breakpoints-get-buffer session))
                (gdb--set-window-buffer middle-u-right (gdb--variables-get-buffer session))
                (gdb--set-window-buffer middle-l-right (gdb--frames-get-buffer session))
                (gdb--set-window-buffer bottom-right (gdb--inferior-io-get-buffer session))
                (gdb--display-source-buffer top-left);;ok
                )))))
  )

(provide 'gdb-settings)
