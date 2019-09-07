;; [[file:~/.emacs.d/myinit.org::*repos][repos:1]]
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
;;(setenv "PATH" (concat "C:/MinGW/bin;" (getenv "PATH")))
;; repos:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Configuraci%C3%B3n%20UTF-8%20para%20emacs][Configuración UTF-8 para emacs:1]]
;; Codificación UTF-8 por defecto
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; Configuración UTF-8 para emacs:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Configuraci%C3%B3n%20de%20bibliografia%20bibtex][Configuración de bibliografia bibtex:1]]
;; Configuración windows
(setq helm-bibtex-bibliography '("./referencias.bib"
                                 "D\:\\Universidad\\ulab\\apuntes\\atomización\\referencias.bib"
                                 ))

;; Configuración de Helm
(setq bibtex-completion-format-citation-functions
      '((org-mode      . bibtex-completion-format-citation-org-link-to-PDF)
        (latex-mode    . bibtex-completion-format-citation-cite)
        (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
        (default       . bibtex-completion-format-citation-default)))
;; Configuración de bibliografia bibtex:1 ends here

;; [[file:~/.emacs.d/myinit.org::*interface%20tweaks][interface tweaks:1]]
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)
;; interface tweaks:1 ends here

;; [[file:~/.emacs.d/myinit.org::*try][try:1]]
(use-package try
	:ensure t)
;; try:1 ends here

;; [[file:~/.emacs.d/myinit.org::*posframe][posframe:1]]
(use-package posframe :ensure t)
;; posframe:1 ends here

;; [[file:~/.emacs.d/myinit.org::*which%20key][which key:1]]
(use-package which-key
  :ensure t 
  :config
  (which-key-mode))

;; (use-package which-key-posframe		;
;;      :ensure t 
;;      :config
;;      (which-key-posframe-mode))
;; which key:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Org%20mode][Org mode:1]]
(require 'org-ref)
(require 'org-ref-pdf)
(require 'org-ref-url-utils)
;;(org-babel-load-file "org-ref.org")

(setq org-ref-default-citation-link "autocite")
;;(setq org-latex-pdf-process (list
;;"latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))

(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))

(use-package org 
  :ensure t
  :pin org)


(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
(custom-set-variables
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-startup-folded (quote overview))
 '(org-startup-indented t)
 '(org-confirm-babel-evaluate nil)
 '(org-src-fontify-natively t)
 )

(setq org-file-apps
      (append '(
                ("\\.pdf\\'" . "okular %s")
                ("\\.x?html?\\'" . "/usr/bin/chromium-browser %s")
                ) org-file-apps ))

(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((agenda "")
          (alltodo "")))))

(global-set-key (kbd "C-c c") 'org-capture)

(defadvice org-capture-finalize 
    (after delete-capture-frame activate)  
  "Advise capture-finalize to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
      (delete-frame)))

(defadvice org-capture-destroy 
    (after delete-capture-frame activate)  
  "Advise capture-destroy to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
      (delete-frame)))  

(use-package noflet
  :ensure t )
(defun make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")))
  (select-frame-by-name "capture")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
    (org-capture)))
;; (require 'ox-beamer)
;; for inserting inactive dates
(define-key org-mode-map (kbd "C-c >") (lambda () (interactive (org-time-stamp-inactive))))

(use-package htmlize :ensure t)

;; Cambia el tamaño de las previstas de latex en orgmode
(plist-put org-format-latex-options :scale 1.5)

;; Configuración de Beamer
(eval-after-load "ox-latex"

  ;; update the list of LaTeX classes and associated header (encoding, etc.)
  ;; and structure
  '(add-to-list 'org-latex-classes
                `("beamer"
                  ,(concat "\\documentclass[presentation]{beamer}\n"
                           "[DEFAULT-PACKAGES]"
                           "[PACKAGES]"
                           "[EXTRA]\n")
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
(setq org-latex-listings t)
;; Org mode:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Ace%20windows%20for%20easy%20window%20switching][Ace windows for easy window switching:1]]
(use-package ace-window
:ensure t
:init
(progn
(setq aw-scope 'global) ;; was frame
(global-set-key (kbd "C-x O") 'other-frame)
  (global-set-key [remap other-window] 'ace-window)
  (custom-set-faces
   '(aw-leading-char-face
     ((t (:inherit ace-jump-face-foreground :height 3.0))))) 
  ))
;; Ace windows for easy window switching:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Swiper%20/%20Ivy%20/%20Counsel][Swiper / Ivy / Counsel:1]]
(use-package counsel
:ensure t
  :bind
  (("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)))




  (use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))


  (use-package swiper
  :ensure t
  :bind (("C-s" . swiper-isearch)
	 ("C-r" . swiper-isearch)
	 ("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))
;; Swiper / Ivy / Counsel:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Avy%20-%20navigate%20by%20searching%20for%20a%20letter%20on%20the%20screen%20and%20jumping%20to%20it][Avy - navigate by searching for a letter on the screen and jumping to it:1]]
(use-package avy
:ensure t
:bind ("M-s" . avy-goto-word-1)) ;; changed from char as per jcs
;; Avy - navigate by searching for a letter on the screen and jumping to it:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Flycheck][Flycheck:1]]
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))
;; Flycheck:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Python][Python:1]]
(setq py-python-command "python3")
        (setq python-shell-interpreter "python3")
 

            (use-package elpy
            :ensure t
:custom (elpy-rpc-backend "jedi")
            :config 

            (elpy-enable)
            
)

        (use-package virtualenvwrapper
          :ensure t
          :config
          (venv-initialize-interactive-shells)
          (venv-initialize-eshell))
;; Python:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Yasnippet][Yasnippet:1]]
(use-package yasnippet
      :ensure t
      :init
        (yas-global-mode 1))

;    (use-package yasnippet-snippets
;      :ensure t)
;; Yasnippet:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Undo%20Tree][Undo Tree:1]]
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))
;; Undo Tree:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Misc%20packages][Misc packages:1]]
; Highlights the current cursor line
  (global-hl-line-mode t)

  ; flashes the cursor's line when you scroll
  (use-package beacon
  :ensure t
  :config
  (beacon-mode 1)
  ; (setq beacon-color "#666600")
  )

  ; deletes all the whitespace when you hit backspace or delete
  (use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))


  (use-package multiple-cursors
  :ensure t)

  ; expand the marked region in semantic increments (negative prefix to reduce region)
  (use-package expand-region
  :ensure t
  :config 
  (global-set-key (kbd "C-=") 'er/expand-region))

(setq save-interprogram-paste-before-kill t)


(global-auto-revert-mode 1) ;; you might not want this
(setq auto-revert-verbose nil) ;; or this
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "<f6>") 'revert-buffer)
;; Misc packages:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Emmet%20mode][Emmet mode:1]]
(use-package emmet-mode
:ensure t
:config
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'web-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
)
;; Emmet mode:1 ends here

;; [[file:~/.emacs.d/myinit.org::*DIRED][DIRED:1]]
; wiki melpa problem
;(use-package dired+
;  :ensure t
;  :config (require 'dired+)
;  )

(setq dired-dwim-target t)

(use-package dired-narrow
:ensure t
:config
(bind-key "C-c C-n" #'dired-narrow)
(bind-key "C-c C-f" #'dired-narrow-fuzzy)
(bind-key "C-x C-N" #'dired-narrow-regexp)
)

(use-package dired-subtree :ensure t
  :after dired
  :config
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map))
;; DIRED:1 ends here

;; [[file:~/.emacs.d/myinit.org::*git][git:1]]
(use-package magit
    :ensure t
    :init
    (progn
    (bind-key "C-x g" 'magit-status)
    ))

(setq magit-status-margin
  '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18))
    (use-package git-gutter
    :ensure t
    :init
    (global-git-gutter-mode +1))

    (global-set-key (kbd "M-g M-g") 'hydra-git-gutter/body)


    (use-package git-timemachine
    :ensure t
    )
  (defhydra hydra-git-gutter (:body-pre (git-gutter-mode 1)
                              :hint nil)
    "
  Git gutter:
    _j_: next hunk        _s_tage hunk     _q_uit
    _k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
    ^ ^                   _p_opup hunk
    _h_: first hunk
    _l_: last hunk        set start _R_evision
  "
    ("j" git-gutter:next-hunk)
    ("k" git-gutter:previous-hunk)
    ("h" (progn (goto-char (point-min))
                (git-gutter:next-hunk 1)))
    ("l" (progn (goto-char (point-min))
                (git-gutter:previous-hunk 1)))
    ("s" git-gutter:stage-hunk)
    ("r" git-gutter:revert-hunk)
    ("p" git-gutter:popup-hunk)
    ("R" git-gutter:set-start-revision)
    ("q" nil :color blue)
    ("Q" (progn (git-gutter-mode -1)
                ;; git-gutter-fringe doesn't seem to
                ;; clear the markup right away
                (sit-for 0.1)
                (git-gutter:clear))
         :color blue))
;; git:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Clojure][Clojure:1]]
(use-package cider
:ensure t)

(add-to-list 'exec-path "/home/zamansky/bin/")
;; Clojure:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Dumb%20jump][Dumb jump:1]]
(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config 
  ;; (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
:init
(dumb-jump-mode)
  :ensure
)
;; Dumb jump:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Origami%20folding][Origami folding:1]]
(use-package origami
:ensure t)
;; Origami folding:1 ends here

;; [[file:~/.emacs.d/myinit.org::*IBUFFER][IBUFFER:1]]
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("org" (name . "^.*org$"))
               ("magit" (mode . magit-mode))
               ("IRC" (or (mode . circe-channel-mode) (mode . circe-server-mode)))
               ("web" (or (mode . web-mode) (mode . js2-mode)))
               ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
               ("mu4e" (or

                        (mode . mu4e-compose-mode)
                        (name . "\*mu4e\*")
                        ))
               ("programming" (or
                               (mode . clojure-mode)
                               (mode . clojurescript-mode)
                               (mode . python-mode)
                               (mode . c++-mode)))
               ("emacs" (or
                         (name . "^\\*scratch\\*$")
                         (name . "^\\*Messages\\*$")))
               ))))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "default")))

;; don't show these
                                        ;(add-to-list 'ibuffer-never-show-predicates "zowie")
;; Don't show filter groups if there are no buffers in that group
(setq ibuffer-show-empty-filter-groups nil)

;; Don't ask for confirmation to delete marked buffers
(setq ibuffer-expert t)
;; IBUFFER:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Treemacs][Treemacs:1]]
(use-package treemacs
    :ensure t
    :defer t
    :config
    (progn

      (setq treemacs-follow-after-init          t
            treemacs-width                      35
            treemacs-indentation                2
            treemacs-git-integration            t
            treemacs-collapse-dirs              3
            treemacs-silent-refresh             nil
            treemacs-change-root-without-asking nil
            treemacs-sorting                    'alphabetic-desc
            treemacs-show-hidden-files          t
            treemacs-never-persist              nil
            treemacs-is-never-other-window      nil
            treemacs-goto-tag-strategy          'refetch-index)

      (treemacs-follow-mode t)
      (treemacs-filewatch-mode t))
    :bind
    (:map global-map
          ([f8]        . treemacs-toggle)
          ([f9]        . treemacs-projectile-toggle)
          ("<C-M-tab>" . treemacs-toggle)
          ("M-0"       . treemacs-select-window)
          ("C-c 1"     . treemacs-delete-other-windows)
        ))
  (use-package treemacs-projectile
    :defer t
    :ensure t
    :config
    (setq treemacs-header-function #'treemacs-projectile-create-header)
)
;; Treemacs:1 ends here

;; [[file:~/.emacs.d/myinit.org::*misc][misc:1]]
(use-package aggressive-indent
:ensure t
:config
(global-aggressive-indent-mode 1)
;;(add-to-list 'aggressive-indent-excluded-modes 'html-mode)
)

(defun z/nikola-deploy () ""
(interactive)
(venv-with-virtualenv "blog" (shell-command "cd ~/gh/cestlaz.github.io; nikola github_deploy"))
)

(defun z/swap-windows ()
""
(interactive)
(ace-swap-window)
(aw-flip-window)
)
;; misc:1 ends here

;; [[file:~/.emacs.d/myinit.org::*personal%20keymap][personal keymap:1]]
;; unset C- and M- digit keys
;(dotimes (n 10)
;  (global-unset-key (kbd (format "C-%d" n)))
;  (global-unset-key (kbd (format "M-%d" n)))
;  )


(defun org-agenda-show-agenda-and-todo (&optional arg)
  (interactive "P")
  (org-agenda arg "c")
  (org-agenda-fortnight-view))

(defun z/load-iorg ()
(interactive )
(find-file "~/Sync/orgfiles/i.org"))

;; set up my own map
(define-prefix-command 'z-map)
(global-set-key (kbd "C-z") 'z-map) ;; was C-1
(define-key z-map (kbd "k") 'compile)
(define-key z-map (kbd "c") 'hydra-multiple-cursors/body)
(define-key z-map (kbd "m") 'mu4e)
(define-key z-map (kbd "1") 'org-global-cycle)
(define-key z-map (kbd "a") 'org-agenda-show-agenda-and-todo)
(define-key z-map (kbd "g") 'counsel-ag)
(define-key z-map (kbd "2") 'make-frame-command)
(define-key z-map (kbd "0") 'delete-frame)
(define-key z-map (kbd "o") 'ace-window)

(define-key z-map (kbd "s") 'flyspell-correct-word-before-point)
(define-key z-map (kbd "i") 'z/load-iorg)
(define-key z-map (kbd "f") 'origami-toggle-node)
(define-key z-map (kbd "w") 'z/swap-windows)
(define-key z-map (kbd "*") 'calc)


  (setq user-full-name "Josué D. Meneses Díaz"
        user-mail-address "josue.meneses@usach.cl")
  ;;--------------------------------------------------------------------------


  (global-set-key (kbd "\e\ei")
                  (lambda () (interactive) (find-file "~/Sync/orgfiles/i.org")))

  (global-set-key (kbd "\e\el")
                  (lambda () (interactive) (find-file "~/Sync/orgfiles/links.org")))

  (global-set-key (kbd "\e\ec")
                  (lambda () (interactive) (find-file "~/.emacs.d/myinit.org")))

(global-set-key (kbd "<end>") 'move-end-of-line)

(global-set-key [mouse-3] 'flyspell-correct-word-before-point)
;; personal keymap:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Wgrep][Wgrep:1]]
(use-package wgrep
:ensure t
)
(use-package wgrep-ag
:ensure t
)
(require 'wgrep-ag)
;; Wgrep:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Silversearcher][Silversearcher:1]]
(use-package ag
:ensure t)
;; Silversearcher:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Regex][Regex:1]]
(use-package pcre2el
:ensure t
:config 
(pcre-mode)
)
;; Regex:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Music][Music:1]]
(use-package simple-mpc
:ensure t)
(use-package mingus
:ensure t)
;; Music:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Atomic%20Chrome%20(edit%20in%20emacs)][Atomic Chrome (edit in emacs):1]]
(use-package atomic-chrome
:ensure t
:config (atomic-chrome-start-server))
(setq atomic-chrome-buffer-open-style 'frame)
;; Atomic Chrome (edit in emacs):1 ends here

;; [[file:~/.emacs.d/myinit.org::*PDF%20tools][PDF tools:1]]
(use-package pdf-tools
:ensure t)
(use-package org-pdfview
:ensure t)

(require 'pdf-tools)
(require 'org-pdfview)
;; PDF tools:1 ends here

;; [[file:~/.emacs.d/myinit.org::*auto-yasnippet][auto-yasnippet:1]]
(use-package auto-yasnippet
:ensure t)
;; auto-yasnippet:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Unfill%20region%20and%20paragraph][Unfill region and paragraph:1]]
;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph    
    (defun unfill-paragraph (&optional region)
      "Takes a multi-line paragraph and makes it into a single line of text."
      (interactive (progn (barf-if-buffer-read-only) '(t)))
      (let ((fill-column (point-max))
            ;; This would override `fill-column' if it's an integer.
            (emacs-lisp-docstring-fill-column t))
        (fill-paragraph nil region)))

(defun unfill-region (beg end)
  "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))
;; Unfill region and paragraph:1 ends here

;; [[file:~/.emacs.d/myinit.org::*Easy%20kill][Easy kill:1]]
(use-package easy-kill
  :ensure t
  :config
  (global-set-key [remap kill-ring-save] #'easy-kill)
  (global-set-key [remap mark-sexp] #'easy-mark))
;; Easy kill:1 ends here
