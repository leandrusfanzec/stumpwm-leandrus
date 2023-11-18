;;; -*-  mode: lisp; -*-
(in-package :stumpwm)
(init-load-path #p"~/.stumpwm.d/modules/")
(let ((quicklisp-init (merge-pathnames ".cache/quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;; Theme
(setf *colors*
      '("#333333"                ; ^0 ; black
        "#BF616A"                ; ^1 ; red
	"#ffa500"                ; ^2 ; orange
        "#A3BE8C"                ; ^3 ; green
        "#EBCB8B"                ; ^4 ; yellow
        "#EBCB8B"                ; ^5 ; blue
        "#B48EAD"                ; ^6 ; magenta
        "#88C0D0"                ; ^7 ; cyan
        "#ECEFF4"                ; ^8 ; white
        ))

(update-color-map (current-screen))

(defparameter *foreground-color* "#ECEFF4")
(defparameter *background-color* "#333333")
(defparameter *border-color* "#ECEFF4")

;; Font
(set-font "-*-cherry-*-*-*-*-13-*-*-*-*-*-*-*")

;; Some commands
(run-shell-command "xset -dpms")
(run-shell-command "xsetroot -cursor_name left_ptr")
(run-shell-command "xwallpaper --zoom '~/Public/misc/333333.png'")

;; messages display time
(setf *timeout-wait* 7)

;; ignore window hints
(setf *ignore-wm-inc-hints* t)

;; input focus is transferred to the window you click on
(setf *mouse-focus-policy* :click)

;;; Basic Settings
(setf *message-window-gravity* :center
      *input-window-gravity* :center
      *window-border-style* :thick
      *message-window-padding* 5
      *input-window-padding* 5)
(set-msg-border-width 2)
(set-fg-color *foreground-color*)
(set-bg-color *background-color*)
(set-border-color *border-color*)

;; Windows
(set-frame-outline-width 3)
(setf *normal-border-width* 2)
(setf *maxsize-border-width* 4)
(setf *transient-border-width* 3)
(set-focus-color *border-color*)
(set-unfocus-color *background-color*)
(setf *window-format* "%m%n%s%20t")

;; Audio
(load-module "pamixer")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "pamixer-volume-up")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "pamixer-volume-down")
(define-key *top-map* (kbd "XF86AudioMute") "pamixer-toggle-mute")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Keybindings                                                             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Algunas modificaciones
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-l") "windowlist")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-o") "grouplist")

;; navigation
;; cycle forward and back through groups
(define-key *top-map* (kbd "s-l") "gnext")
(define-key *top-map* (kbd "s-h") "gprev")

;; cycle through windows using Super key + arrows
(define-key *top-map* (kbd "s-Right") "pull-hidden-next")
(define-key *top-map* (kbd "s-Left") "pull-hidden-previous")

(define-key *top-map* (kbd "s-SPC") "fnext")

(define-remapped-keys
 '(("(firefox|mpv)"
    ("C-y"   . "C-v")
    ("M-w"   . "C-c")
    ("C-n"   . "Down")
    ("C-p"   . "Up")
    ("C-f"   . "Right")
    ("C-b"   . "Left")
    ("C-v"   . "Next"))))

;; Launcher
;; run or raise Firefox
(defcommand firefox () ()
	    "Start Firefox or switch to it, if it is already running"
	    (run-or-raise "firefox -P chad" '(:class "firefox")))
(define-key *root-map* (kbd "w") "firefox")

;; Lf
(define-key *root-map* (kbd "C-f") "exec alacritty -T Archivos -e ~/.local/bin/lfub")
;; Ytfzf - Video
(define-key *root-map* (kbd "Y") "exec alacritty -T '© Youtube - Video' -e ytfzf -st")
;; Ytfzf - Music
(define-key *root-map* (kbd "y") "exec alacritty -T '© Youtube - Music' -e ytfzf -stm")
;; Pulsemixer
(define-key *root-map* (kbd "C-m") "exec alacritty -T Audio -e pulsemixer")
;; Thunar
(define-key *root-map* (kbd "F") "exec Thunar")
;; Htop
(define-key *top-map* (kbd "s-t") "exec alacritty -T Monitor -e htop")

;; open terminal
(define-key *root-map* (kbd "Return") "exec alacritty")
(define-key *root-map* (kbd "c") "exec alacritty")
(define-key *root-map* (kbd "C-c") "exec alacritty")

;; hard restart keybinding (Super + r)
(define-key *top-map* (kbd "s-R") "restart-hard")
(define-key *top-map* (kbd "s-r") "refresh")

;;; Groups
(grename "EMACS")
(gnewbg "OTROS")
(gnewbg-float "FLOAT")
;;(gnewbg ".scratchpad") ; hidden group / scratchpad
;; Groups Name
(setf *group-format* " %t ")
;; Global Windows
(load-module "globalwindows")
(define-key *root-map* (kbd "b") "global-windowlist")
(define-key *top-map* (kbd "M-2") "global-pull-windowlist")

;; Windows rules
(define-frame-preference "OTROS"
			 (0 nil T :class "thunderbird")
			 (1 nil T :class "firefox"))
;;; Gaps
(load-module "swm-gaps")
(setf swm-gaps:*inner-gaps-size* 13
      swm-gaps:*outer-gaps-size* 7
      swm-gaps:*head-gaps-size* 0)
(when *initializing*
  (swm-gaps:toggle-gaps))
(define-key *groups-map* (kbd "g") "toggle-gaps")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Modeline settings                                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-module "wifi")
(load-module "battery-portable")

(setf *time-modeline-string* "%a, %b %d %I:%M%p")
(setf *screen-mode-line-format*
      (list
       ;; Groups
       " ^4[%g]^n "
       ;; Windows
       "%W"
       ;; Pad to right
       "^>"
       '(:eval (when (> *reps* 0)
		 (format nil "^1^B(Reps ~A)^n " *reps*)))
       ;; Notifications
       "%N "
       ;; Date
       "^8"
       "%d -*- "
       ;; Wifi
       "[W:%I]"
       ;; Battery
       " ^3[^n%B^3]^n "))

(defun enable-mode-line-everywhere ()
  (loop for screen in *screen-list* do
    (loop for head in (screen-heads screen) do
      (enable-mode-line screen head t))))
(enable-mode-line-everywhere)

(setf *mode-line-border-width* 0)
(setf *mode-line-pad-y* 5)
(setf *mode-line-pad-x* 10)

(setf *bar-med-color* "^B^8")
(setf *bar-hi-color* "^B^4")
(setf *bar-crit-color* "^B^1")
(setf *hidden-window-color* "^7")

;; the foreground is the highlight for the windows too
(setf *mode-line-background-color* *background-color*)
(setf *mode-line-foreground-color* *foreground-color*)

;; Slynk
(ql:quickload "slynk")
(require :slynk)
(defcommand stump-slynk-server () ()
	    (slynk:create-server :port 4004
				 :dont-close t))
(stump-slynk-server)

;; Clipboard
(load-module "clipboard-history")
(define-key *root-map* (kbd "C-y") "show-clipboard-history")
;; start the polling timer process
(clipboard-history:start-clipboard-manager)

;; PowerMenu
(load-module "end-session")
(define-key *top-map* (kbd "s-ESC") "end-session")

;; Pomodoro
(load-module "notifications")  ; optionally, goes before `swm-pomodoro`
(load-module "swm-pomodoro")

;; Documentation
(load-module "undocumented")

(load-module "global-windows")
(define-key *root-map* (kbd "C-t") "global-other")
(define-key *root-map* (kbd "b") "global-windowlist")
(define-key *root-map* (kbd "C-b") "global-pull-windowlist")

;; startup message
(setf *startup-message* "^5    Stump Window Manager ^nhas initialized!
Press ^6Ctrl+t ? ^nfor Help. ^2Never Stop Hacking!^n
          Powered with ^1 Common Lisp ")

;; Save command history 
(load-module "command-history")

;; Take screenshot
(load-module "screenshot")

;; Remember commands and offers orderless completion
;; https://github.com/landakram/stumpwm-prescient
(ql:quickload :stumpwm-prescient)
(setf *input-refine-candidates-fn* 'stumpwm-prescient:refine-input)

(redirect-all-output (data-dir-file "stumpwm.log" "txt"))
