;; Launch a debugger with a stactrace if there's any error in Emacs lisp.
;; This is especially helpful on startup, when your init.el has an error.
(setq debug-on-error t)

;;
;; Color scheme
;;
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'flatland t)

;; Remove the titlebar on OSX, so that Emacs occupies the entire screen.
;; (set-frame-parameter nil 'undecorated t) ; This prevents Emacs from being controlled by Hammerspoon on OSX.
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;; Turn off graphical toolbars.
(if (display-graphic-p) (menu-bar-mode 1) (menu-bar-mode -1))
(when (and (fboundp 'tool-bar-mode) tool-bar-mode) (tool-bar-mode -1))
(when (and (fboundp 'scroll-bar-mode) scroll-bar-mode) (scroll-bar-mode -1))

;; Make it possible to open files via the command line in this Emacs using `emacsclient`.
(require 'server)

;; Reload an open file from disk if it is changed outside of Emacs.
(global-auto-revert-mode 1)

;;
;; Package management
;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.melpa.org/packages/"))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(magit enh-ruby-mode rspec-mode slime xcode-project ))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Whitespace & line wrapping.
(global-whitespace-mode t)
(with-eval-after-load "whitespace"
  (setq whitespace-line-column 110) ; When text flows past 110 chars, highlight it.
  ;; whitespace-mode by default highlights all whitespace. Show only tabs and trailing spaces.
  (setq whitespace-style '(face trailing lines-tail)))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq-default tab-width 4)
;; Some modes have their own tab-width variables which need to be overridden.
(setq-default css-indent-offset 4)

(setq sentence-end-double-space nil) ; Don't add double spaces after periods when filling strings in quotes.
(setq-default fill-column 110) ; When wrapping with the Emacs fill commands, wrap at 110 chars.
(auto-fill-mode t) ; When typing across the fill-column, hard-wrap the line as you type.
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; Some modes, like markdown, turn off autofill. Force it!

;; Visually wrap long lines on word boundaries. By default, Emacs will wrap mid-word. Note that Evil doesn't
;; have good support for moving between visual lines versus logical lines. Here's the start of a solution:
;; https://lists.ourproject.org/pipermail/implementations-list/2011-December/001430.html
(global-visual-line-mode t)

;; Highlight the line the cursor is on. This is mostly to make it easier to tell which split is active.
(global-hl-line-mode)
;; Don't blink the cursor. I can easily see it, because the line the cursor is on is already highlighted.
(blink-cursor-mode -1)

;; Indent with spaces instead of tabs by default. Modes that really need tabs should enable indent-tabs-mode
;; explicitly. Makefile-mode already does that, for example. If indent-tabs-mode is off, replace tabs with
;; spaces before saving the file.
(setq-default indent-tabs-mode nil)
(add-hook 'write-file-hooks
          (lambda ()
            (if (not indent-tabs-mode)
                (untabify (point-min) (point-max)))
            nil))

;; The preference file for Emac's "Customize" system. `M-x customize` to access it.
(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file t)
