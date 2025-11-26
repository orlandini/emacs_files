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



;; taken from https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/
(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))


(require 'dwim-shell-command)




(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)
(define-key dired-mode-map [remap dired-do-async-shell-command] 'dwim-shell-command)
(define-key dired-mode-map [remap dired-do-shell-command] 'dwim-shell-command)
(define-key dired-mode-map [remap dired-smart-shell-command] 'dwim-shell-command)
(global-set-key (kbd "C-s") 'ar/swiper-dwim)
(global-set-key (kbd "C-r") 'ar/swiper-backward-dwim)
(global-set-key (kbd "M-u") 'upcase-dwim)
(global-set-key (kbd "M-l") 'downcase-dwim)
(global-set-key (kbd "M-c") 'capitalize-dwim)


(provide 'dwim-settings)