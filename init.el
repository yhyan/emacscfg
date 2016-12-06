
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    sr-speedbar
    elpy
    flycheck
    org
    yasnippet
    material-theme
    py-autopep8))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

(load-theme 'material t) ;; load material theme

;;(setq sr-speedbar-width 30)
;;(setq sr-speedbar-right-side nil) ; put on left side
;;(sr-speedbar-open) ;; 打开buffer和文件列表窗口

;;(elpy-enable)  ;; 启用elpy
;;(elpy-use-ipython)


;; 先不启用pep8 保存
(require 'py-autopep8)
;;(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)  ;; pep8 保存

;;(add-hook 'after-init-hook #'global-flycheck-mode)  ;; enable flycheck

;;(require 'yasnippet)
;;(yas-global-mode 1)

;; Makes *scratch* empty.
(setq initial-scratch-message "")
;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Don't show *Buffer list* when opening multiple files at the same time.
(setq inhibit-startup-buffer-menu t)
;; Show only one active window when opening multiple files at the same time.
(add-hook 'window-setup-hook 'delete-other-windows)

(defun copy-to-clipboard ()
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard!")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard!")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard!")))
  )

(defun paste-from-clipboard ()
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "graphics active")
        )
    (insert (shell-command-to-string "xsel -o -b"))
    )
  )

(defun isolate-kill-ring()
  "Isolate Emacs kill ring from OS X system pasteboard.
This function is only necessary in window system."
  (interactive)
  (setq interprogram-cut-function nil)
  (setq interprogram-paste-function nil))

(defun pasteboard-copy()
  "Copy region to OS X system pasteboard."
  (interactive)
  (shell-command-on-region
   (region-beginning) (region-end) "pbcopy"))

(defun pasteboard-paste()
  "Paste from OS X system pasteboard via `pbpaste' to point."
  (interactive)
  (shell-command-on-region
   (point) (if mark-active (mark) (point)) "pbpaste" nil t))

(defun pasteboard-cut()
  "Cut region and put on OS X system pasteboard."
  (interactive)
  (pasteboard-copy)
  (delete-region (region-beginning) (region-end)))

;; bind CMD+C to pasteboard-copy
(global-set-key [f8] 'pasteboard-copy)
;; bind CMD+V to pasteboard-paste
(global-set-key [f9] 'pasteboard-paste)
;; bind CMD+X to pasteboard-cut
(global-set-key (kbd "s-x") 'pasteboard-cut)

;;(global-set-key [f8] 'copy-to-clipboard)
;;(global-set-key [f9] 'paste-from-clipboard)


(setq column-number-mode t)
(setq make-backup-files nil)
(setq x-select-enable-clipboard t)

(setq global-linum-mode t)
(setq linum-format "%4d \u2502")
(add-hook 'prog-mode-hook 'linum-mode)

(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'window-numbering)
(window-numbering-mode 1)


(add-to-list 'load-path "~/.emacs.d/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/ac-dict")
(ac-config-default)

(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'ruby-mode-hook 'hs-minor-mode)
(add-hook 'javascript-mode-hook 'hs-minor-mode)
(add-hook 'js-mode-hook 'hs-minor-mode)


(global-set-key [f1] 'hs-toggle-hiding)
(global-set-key [f2] 'hs-hide-all)
(global-set-key [f3] 'hs-show-all)

(define-coding-system-alias 'UTF-8 'utf-8)



(defun indent-whole ()
  "Indent the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(global-set-key [f7] 'indent-whole)

(setq require-final-newline 'visit-save)
(setq delete-trailing-lines nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

