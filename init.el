;; Launch a debugger with a stactrace if there's any error in Emacs lisp.
;; This is especially helpful on startup, when your init.el has an error.
(setq debug-on-error t)

;;
;; Color scheme
;;
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'flatland t)

;; Reload an open file from disk if it is changed outside of Emacs.
(global-auto-revert-mode 1) 
