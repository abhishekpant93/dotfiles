;;------------
;;;Proxy
;;------------

(setq url-proxy-services '(("http" . "10.3.100.207:8080")
                          ("https" . "10.3.100.207:8080")))

;;------------
;;;Package Management
;;-------------

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;------------
;;;Custom Configuration
;;------------

; Custom theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn 1)

; Inhibit welcome screen
(custom-set-variables
 '(inhibit-startup-screen 1))

; Start emacs maximized.
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(set-face-attribute 'default nil :font "Andale Mono-18")

(setq tab-width 4)

(show-paren-mode 1)
(electric-indent-mode 1)
(electric-pair-mode 1)

(global-linum-mode 1)
(setq column-number-mode 1)

; Interactive-do
(require 'ido)
(setq ido-enable-flex-matching 1)
(setq ido-everywhere 1)
(ido-mode 1)

(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; (require 'yasnippet)
;; (yas-global-mode 1)

;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

(add-hook 'after-init-hook 'global-company-mode)

;;------------
;;;C/C++
;;------------

(require 'cc-mode)

; Fix iedit key-binding bug in Mac OS
(define-key global-map (kbd "C-c ;") 'iedit-mode)

; Initializes flymake-google-cpp-lint
(defun my-flymake-google-init ()
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
  (flymake-google-cpplint-load))

(add-hook 'c++-mode-hook 'my:flymake-google-init)
(add-hook 'c-mode-hook 'my:flymake-google-init)

(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)

; replace the `completion-at-point' and `complete-symbol' bindings in
; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
(add-hook 'irony-mode-hook 'irony-eldoc)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-c-headers))

(require 'clang-format)
(global-set-key [C-tab] 'clang-format)

(defvaralias 'c-basic-offset 'tab-width)

;;------------
;;;Python
;;------------

(elpy-enable)

; use IPython
(require 'python)
(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "--pylab")

; switch to interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute-p t)
; don't split windows
(setq py-split-windows-on-execute-p nil)
(setq py-smart-indentation t)

(setq elpy-rpc-backend "jedi")

(defun my-python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my-python-mode-hook)

(provide '.emacs)
;;; .emacs ends here
