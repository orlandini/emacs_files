;;; package -- Summary: fortran setings for Emacs
;;; Commentary:
                                        ; nothing special

;;; Code:

;; diogenes stuff
(setq f90-auto-keyword-case 'upcase-word)
(setq f90-program-indent 3)
(setq f90-associate-indent 3)
(setq f90-critical-indent 3)

(defun do-lines (fun &optional start end)
  "Invoke function FUN on the text of each line from START to END."
  (interactive
   (let ((fn   (intern (completing-read "Function: " obarray 'functionp t))))
     (if (use-region-p)
         (list fn (region-beginning) (region-end))
       (list fn (point-min) (point-max)))))
  (save-excursion
    (goto-char start)
    (while (< (point) end)
      (funcall fun (buffer-substring (line-beginning-position) (line-end-position)))
      (forward-line 1))))

;; (defun my-f90-mode-hook ()
;;   (setq indent-region-function '(do-lines f90-update-line)))
;; (add-hook 'f90-mode-hook 'my-f90-mode-hook)



;;;; this file contains an interface to use findent within emacs.
;;;; the C-M-q command ("indent function") is redefined to
;;;; indent the whole buffer.
                                        ; how to call findent for a fixed format Fortran source:
(defvar fortran-findent-command 
  "~/miniconda3/envs/diogenes/bin/findent -ifixed -Ia"
  "findent command for fixed format fortran source")
                                        ;
                                        ; how to call findent for a free format Fortran source:
(defvar f90-findent-command 
  "~/miniconda3/envs/diogenes/bin/findent -ifree -Ia"
  "findent command for free format fortran source")
                                        ;
;;;; define function findent-indent-buffer: it calls the program
;;;; findent with the whole buffer as input and output
(defun findent-indent-buffer()
  " 
  Function that uses findent to indent the whole buffer.
  The call to findent must be provided in the string findent-command,
    for example (setq findent-command \"findent -ifixed -Ia\")
  Findent supports Fortran-2008, free and fixed format;
    indents correctly DO statements that share a common label;
    is in general not confused by #if, #ifdef or #else preprocessor
    statements.
  "
  (interactive)

  (let (
        (lines (count-lines (point-min) (point-max)))
        (lpos (line-number-at-pos))
        (first-window-line)
        (offset)
        (linelength)
        (pos (point))
        )
                                        ; this function tries to restore cursor and window
                                        ; position after indenting, hence the extra code.
                                        ; If somebody knows something better ...
    (beginning-of-line)
    (end-of-line)
    (skip-chars-backward "[:blank:]")
    (setq offset (- (point) pos))
    (if (< offset 0) (setq offset 0))
    (move-to-window-line 0)
    (setq first-window-line (line-number-at-pos))
    (message "indenting buffer ..." )
    (shell-command-on-region (point-min) (point-max) findent-command 1 1 )
    (goto-line lpos)
    (redisplay)
    (move-to-window-line 0)
    (scroll-down (- (line-number-at-pos) first-window-line))
    (goto-line lpos)
    (setq pos (point))
    (end-of-line)
    (setq linelength (- (point) pos))
    (if (< offset linelength)
        (backward-char offset)
      (beginning-of-line))
    (message "indenting buffer ... %d lines indented" lines)
    )
  )
                                        ;
(add-hook 'fortran-mode-hook (lambda() (setq findent-command fortran-findent-command)))
(add-hook 'f90-mode-hook     (lambda() (setq findent-command f90-findent-command)))
(add-hook 'fortran-mode-hook (lambda() (local-set-key "\C-\M-q" 'findent-indent-buffer)))
(add-hook 'f90-mode-hook     (lambda() (local-set-key "\C-\M-q" 'findent-indent-buffer)))

;; Description: Alignment rules for Fortran 90
;; Author: Jannis Teunissen
;; Copyright (C) 2016 by Jannis Teunissen
;; Last-Updated: Thu Apr 21 19:24:46 2016 (+0200)
;;
;; Usage:
;; (require 'align-f90)
;; (align-f90-load)
;;
;; Then you can call align-current to align the current region.
;;
;; Supported features:
;; Alignment of declarations (those that use ::) and assignments in the current
;; "region". Regions are separated by empty lines or Fortran keywords such as
;; do, subroutine, end etc.
;;
;; TODO:
;; - Incorporate support for labels in regexps
;;
;;; Change Log:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar align-f90-modes '(f90-mode))

(defvar align-f90-region-separators
                    (concat
                     "\\(^\\s-*$\\|" ; Empty line
                     "^\\s-*do\\b\\|" ; Fortran keywords for blocks
                     "^\\s-*end\\|"
                     "^\\s-*else\\b\\|"
                     "^\\s-*block\\b\\|"
                     "^\\s-*program\\b\\|"
                     "^\\s-*module\\b\\|"
                     "^\\s-*submodule\\b\\|"
                     "^\\s-*function\\b\\|"
                     "^\\s-*subroutine\\b\\|"
                     "^\\s-*interface\\b\\|"
                     "^\\s-*type\s-+[^(]\\|"
                     "^\\s-*use\\b\\|"
                     "^\\s-*if\\b\\|"
                     "^\\s-*where\\b\\|"
                     "^\\s-*case\\b\\|"
                     "^\\s-*forall\\b\\|"
                     "^\\s-*select\\b\\)")
                    "A list of block delimiters in F90")

(defun align-f90-load ()
  "Enable F90 alignment"
  (interactive)

  ;; Auto load align rules
  (eval-after-load 'align
    '(align-f90-add-rules))

  ;; Add hook to set the region separators
  (add-hook 'f90-mode-hook 'align-f90-region-hook))

(defun align-f90-region-hook ()
  (make-local-variable 'align-region-separate)
  (setq align-region-separate align-f90-region-separators))

(defun align-f90-add-rules ()
  "Add F90 align rules"

  (add-to-list 'align-rules-list
               '(f90-assignment
                 (regexp . "[^=<>/ 	\n]\\(\\s-*[=<>/]*\\)=[>]?\\(\\s-*\\)\\([^= 	\n]\\|$\\)")
                 (group 1 2)
                 (modes . align-f90-modes)
                 (justify . t)))

  (add-to-list 'align-rules-list
               '(f90-declaration
                 (regexp . "[^ 	\n]\\(\\s-*\\)::\\(\\s-*\\)\\([^ 	\n]\\|$\\)")
                 (group 1 2)
                 ;; (separate . "entire")
                 (modes . align-f90-modes)
                 (justify . t)))

  (add-to-list 'align-rules-list
               '(f90-comment
                 (regexp . "[^ 	\n]\\(\\s-*\\)\\(!.*\\)$")
                 (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-func-params
                (regexp . "(\\([^)\n]+\\))")
                (repeat . t)
                (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-macro
                (regexp . "^\\s-*#\\s-*\\(if\\w*\\|elif\\|endif\\)\\(.*\\)$")
                (group . 2)
                (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-do-loops
                 (regexp . "^\\s-*do\\b\\(.+\\)$")
                 (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-comment
                 (regexp . "!\\(.+\\)$")
                 (modes . align-f90-modes))))

(provide 'fortran-settings)
;;; fortran-settings.el ends here