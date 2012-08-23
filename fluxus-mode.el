(require 'osc)

(defvar osc-host "127.0.0.1")
(defvar osc-port 34343)

(setf fluxus-client (osc-make-client osc-host osc-port))

(defun fluxus-send-text (start end)
  (osc-send-message fluxus-client
                    "/code"
                    (buffer-substring-no-properties
                     start end)))

(defun current-task ()
  (car (split-string (buffer-name) "\\.")))
    
(defun fluxus-spawn-task ()
  "spawn the task named as the filename"
  (interactive)
  (osc-send-message fluxus-client "/spawn-task" (current-task)))

(defun fluxus-rm-task ()
  "remove the current task"
  (interactive)
  (osc-send-message fluxus-client "/rm-task" (current-task)))

(defun fluxus-rm-all-tasks ()
  "remove all tasks"
  (interactive)
  (osc-send-message fluxus-client "/rm-all-tasks" ""))     

(defun fluxus-clear ()
  "clear fluxus screen"
  (interactive)
  (osc-send-message fluxus-client "/clear" ""))
    
(defun fluxus-send-region ()
  "send a region to fluxus via osc .."
  (interactive)
  (fluxus-send-text (region-beginning) (region-end)))

(defun fluxus-send-buffer ()
  "send the current buffer to fluxus via osc.. ."
  (interactive)
  (fluxus-send-text (point-min) (point-max)))

(defun fluxus-load ()
  "loads the current file"
  (interactive)
  (osc-send-message fluxus-client "/load" buffer-file-name))

(defun fluxus-load-and-spawn ()
  "loads and spawns current file"
  (interactive)
  (fluxus-load)
  (fluxus-spawn-task))

(defun fluxus-send-via-shell (start end)
  (shell-command-on-region start end
                           (append "sendOSC -h " osc-host " " (number-to-string osc-port) " /code ")))

(defun osc-make-client (host port)
  (make-network-process
   :name "OSC client"
   :host host
   :service port
   :type 'datagram
   :family 'ipv4))

(defun fluxus-cleanup ()
  (delete-process fluxus-client))

(defconst fluxus-keywords1
  (regexp-opt
   '("start-audio" "colour" "vector" "gh" "gain"
     "build-cube" "build-sphere" "build-plane" "every-frame"
     "scale" "translate" "rotate" "with-state" "clear"
     "destroy" "with-primitive" "parent" "time" "delta"
     "texture" "opacity" "pdata-map!" "build-torus"
     "build-seg-plane" "build-cylinder" "build-polygons")))

(defconst fluxus-keywords (append "\\<" fluxus-keywords1 "\\>"))

(defvar fluxus-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<f5>") 'fluxus-load)
    (define-key map (kbd "<f6>") 'fluxus-spawn-task)
    (define-key map (kbd "<f7>") 'fluxus-rm-task)
    (define-key map (kbd "<f8>") 'fluxus-rm-all-tasks)
    (define-key map (kbd "<f9>") 'fluxus-clear)
    (define-key map (kbd "<f10>") 'fluxus-send-region)
    map)
  "keymap for fluxus-mode")

(define-derived-mode fluxus-mode scheme-mode
  "fluxus-mode"
  "derived scheme mode"
  (font-lock-add-keywords nil `((,fluxus-keywords1 . 'font-lock-function-name-face))))
(add-to-list 'auto-mode-alist '("\\.flx\\'" . fluxus-mode))

(provide 'fluxus-mode)
