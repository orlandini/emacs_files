(defun ar/swiper-dwim ()
  (interactive)
  ;; Are we using multiple cursors?
  (cond ((and (boundp 'multiple-cursors-mode)
              multiple-cursors-mode
              (fboundp  'phi-search))
         (call-interactively 'phi-search))
        ;; Are we defining a macro?
        (defining-kbd-macro
          (call-interactively 'isearch-forward))
        ((eq major-mode 'pdf-view-mode) (call-interactively 'isearch-forward))
        ;; Fall back to swiper.
        (t
         ;; Wrap around swiper results.
         (let ((ivy-wrap t))
           ;; If region is active, prepopulate swiper's search term.
           (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
               (let ((region (buffer-substring-no-properties (mark) (point))))
                 (deactivate-mark)
                 (swiper region))
             (swiper))))))

(defun ar/swiper-backward-dwim ()
  (interactive)
  ;; Are we using multiple cursors?
  (cond ((and (boundp 'multiple-cursors-mode)
              multiple-cursors-mode
              (fboundp  'phi-search-backward))
         (call-interactively 'phi-search-backward))
        ;; Are we defining a macro?
        (defining-kbd-macro
          (call-interactively 'isearch-backward))
        ((eq major-mode 'pdf-view-mode) (call-interactively 'isearch-bacward))
        ;; Fall back to swiper.
        (t
         ;; Wrap around swiper results.
         (let ((ivy-wrap t))
           ;; If region is active, prepopulate swiper's search term.
           (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
               (let ((region (buffer-substring-no-properties (mark) (point))))
                 (deactivate-mark)
                 (swiper-backward region))
             (swiper-backward))))))


(require 'dwim-shell-command)




(define-key dired-mode-map [remap dired-do-async-shell-command] 'dwim-shell-command)
(define-key dired-mode-map [remap dired-do-shell-command] 'dwim-shell-command)
(define-key dired-mode-map [remap dired-smart-shell-command] 'dwim-shell-command)
(global-set-key (kbd "C-s") 'ar/swiper-dwim)
(global-set-key (kbd "C-r") 'ar/swiper-backward-dwim)
(global-set-key (kbd "M-u") 'upcase-dwim)
(global-set-key (kbd "M-l") 'downcase-dwim)
(global-set-key (kbd "M-c") 'capitalize-dwim)


(provide 'dwim-settings)