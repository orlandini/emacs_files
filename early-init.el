(defvar default-gc-cons-threshold 16777216 ; 16mb
  "my default desired value of `gc-cons-threshold'
during normal emacs operations.")

;; make garbage collector less invasive
(setq gc-cons-threshold  most-positive-fixnum
      gc-cons-percentage 0.6)
;;https://emacs-lsp.github.io/lsp-mode/page/performance/#use-plists-for-deserialization
(setenv "LSP_USE_PLISTS" "true")

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(menu-bar-modes . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(tool-bar-modes . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(set-face-attribute 'default nil
                    :family "Fira Code"
                    :height 120
                    ;; :weight 'normal
                    ;; :width 'normal
                    )

(setq default-file-name-handler-alist file-name-handler-alist
      file-name-handler-alist nil)



(add-hook 'emacs-startup-hook
          (lambda (&rest _)
            (setq gc-cons-threshold default-gc-cons-threshold
                  gc-cons-percentage 0.1
                  file-name-handler-alist default-file-name-handler-alist)

            ;; delete no longer necessary startup variable
            (makunbound 'default-file-name-handler-alist)))
