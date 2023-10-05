;; init config
;; test

(unless (bound-and-true-p package-user-dir)
  (defvar package-user-dir nil
    "package user's directory for elpa."))

(unless (bound-and-true-p package-archives)
  (defvar package-archives nil
    "package archives address."))

(setq package-user-dir (expand-file-name "elpa" user-emacs-directory)
      package-archives
      '(("gnu-tsinghua" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa-tsinghua" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("melpa-stable-tshinghua" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")
        ("org-tsinghua" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
        ;; ("gnu-tencent" . "http://mirrors.cloud.tencent.com/elpa/gnu/")
        ;; ("melpa-tencent" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
        ;; ("melpa-stable-tencent" . "http://mirrors.cloud.tencent.com/elpa/melpa-stable/")
        ;; ("org-tencent" . "http://mirrors.cloud.tencent.com/elpa/org/")
        ;; ("gnu-emacs-china" . "http://elpa.emacs-china.org/gnu/")
        ;; ("melpa-emacs-china" . "http://elpa.emacs-china.org/melpa/")
        ;; ("melpa-stable-emacs-china" . "http://elpa.emacs-china.org/melpa-stable/")
        ;; ("org-emacs-china" . "http://elpa.emacs-china.org/org/")
        ("cselpa" . "https://elpa.thecybershadow.net/packages/")))

(require 'package)

(unless (bound-and-true-p package--initialized)
  ; To prevent initializing twice
  (setq package-enable-at-startup nil)
  (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-verbose (not (bound-and-true-p byte-compile-current-file)))
  (setq use-package-always-ensure t)
  (setq use-package-expand-minimally t)
  (setq use-package-compute-statistics t)
  (setq use-package-enable-imenu-support t))

(eval-when-compile
  (require 'use-package)
  (require 'bind-key))

(global-display-line-numbers-mode)
(line-number-mode)
(column-number-mode)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq-default electric-indent-inhibit t)
(setq indent-line-function nil)
(setq make-backup-files nil)

(setq inhibit-startup-message t)



(defvar te/user-nick-name nil
  "User's nickname for current user.")

(setq user-full-name "Aaron Liew")
(setq te/user-nick-name "Tabuyos")
(setq user-mail-address "tabuyos@outlook.com")

(defconst *sys/windows*
  (eq system-type 'windows-nt)
  "Are we running on a Windows system?")

(defconst *sys/linux*
  (eq system-type 'gnu/linux)
  "Are we running on a GNU/Linux system?")

(defconst *sys/mac*
  (eq system-type 'darwin)
  "Are we running on a Mac system?")

(defconst *sys/python*
  (executable-find "python")
  "Do we have python?")

(defconst *sys/pip*
  (executable-find "pip")
  "Do we hava pip?")

(defconst *sys/clangd*
  (executable-find "clangd")
  "Do we have clangd?")

(defconst *sys/eaf-env*
  (and *sys/linux* (display-graphic-p) *sys/python* *sys/pip*
       (not (equal (shell-command-to-string "pip freeze | grep '^PyQt\\|PyQtWebEngine'") "")))
  "Do we have EAF environment setup?")

(use-package sudo-edit
             :commands (sudo-edit))

(unless *sys/windows*
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-language-environment 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8))

(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

(defun te/delete-trailing-whitespace-except-current-line ()
  "An alternative to `delete-trailing-whitespace'.
The original function deletes trailing whitespace of the current line."
  (interactive)
  (let ((begin (line-beginning-position))
        (end (line-end-position)))
    (save-excursion
      (when (< (point-min) (1- begin))
        (save-restriction
          (narrow-to-region (point-min) (1- begin))
          (delete-trailing-whitespace)
          (widen))))))

(defun te/smart-delete-trailing-whitespace ()
  "Invoke `te/delete-trailing-whitespace-except-current-line' on selected major modes only."
  (unless (member major-mode '(diff-mode))
    (te/delete-trailing-whitespace-except-current-line)))

(add-hook 'before-save-hook #'te/smart-delete-trailing-whitespace)

(save-place-mode 1)
(delete-selection-mode 1)
(setq x-alt-keysym 'meta)
(setq echo-keystrokes 0.1)
(setq confirm-kill-emacs 'y-or-n-p)
(setq ring-bell-function 'ignore)
(setq ad-redefinition-action 'accept)
(setq-default history-length 500)
(setq-default create-lockfiles nil)
(setq-default compilation-always-kill t)
(setq-default compilation-ask-about-save t)
(setq-default compilation-scroll-output t)

(setq custom-file (concat user-emacs-directory "custom-set-variables.el"))
(load custom-file 'noerror)

(when (fboundp 'global-so-long-mode)
  (global-so-long-mode))

(setq require-final-newline t)

(add-to-list 'auto-mode-alist '("\\.in\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.out\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.args\\'" . text-mode))

(use-package recentf
             :ensure nil
             :hook (after-init . recentf-mode)
             :custom
             (recentf-auto-cleanup "05:00am")
             (recentf-max-saved-items 200)
             (recentf-exclude '((expand-file-name package-user-dir)
		                            ".cache"
                                ".cask"
                                ".elfeed"
                                "bookmarks"
                                "cache"
                                "ido.*"
                                "persp-confs"
                                "recentf"
                                "undo-tree-hist"
                                "url"
                                "COMMIT_EDITMSG\\'")))


;; move line up
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

;; move line down
(defun move-line-down ()
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))



(defun move-lines (n)
  (let ((beg) (end) (keep))
    (if mark-active
        (save-excursion
          (setq keep t)
          (setq beg (region-beginning)
                end (region-end))
          (goto-char beg)
          (setq beg (line-beginning-position))
          (goto-char end)
          (setq end (line-beginning-position 2)))
      (setq beg (line-beginning-position)
            end (line-beginning-position 2)))
    (let ((offset (if (and (mark t)
                           (and (>= (mark t) beg)
                                (< (mark t) end)))
                      (- (point) (mark t))))
          (rewind (- end (point))))
      (goto-char (if (< n 0) beg end))
      (forward-line n)
      (insert (delete-and-extract-region beg end))
      (backward-char rewind)
      (if offset (set-mark (- (point) offset))))
    (if keep
        (setq mark-active t
              deactivate-mark nil))))

(defun move-lines-up (n)
  "move the line(s) spanned by the active region up by N lines."
  (interactive "*p")
  (move-lines (- (or n 1))))

(defun move-lines-down (n)
  "move the line(s) spanned by the active region down by N lines."
  (interactive "*p")
  (move-lines (or n 1)))

(global-set-key [(meta p)] 'move-lines-up)
(global-set-key [(meta n)] 'move-lines-down)


(use-package doom-themes
  :custom-face
  (cursor ((t (:background "BlanchedAlmond"))))
  :config
  ;; flashing mode-line on errors.
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (load-theme 'doom-one t))





(defun te/update-to-load-path (folder)
  "Update FOLDER and it's subdirectories to `load-path'."
  (let ((base folder))
    (unless (member base load-path)
      (add-to-list 'load-path base))
    (dolist (cf (directory-files base))
      (let ((name (concat base "/" cf)))
        (when (and (file-directory-p name)
                   (not (equal cf ".."))
                   (not (equal cf ".")))
          (unless (member base load-path)
            (add-to-list 'load-path name)))))))

(te/update-to-load-path (expand-file-name "emacs-lisp" user-emacs-directory))

(require 'init-theme)

(require 'init-org)
