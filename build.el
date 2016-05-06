;; Build file for setting up dot-files

(require 'org)
(require 'ob)
(require 'ob-tangle)


;; to cleanup, on the mac this is a strange dir.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defconst bb/emacs-directory (concat (getenv "HOME") "/.emacs.d"))
(defconst bb/emacs-subdirectories '("elisp" "snippets"))

(defun bb/build-dot-files ()
  (interactive)

  ;; Get the path to for this file.
  (defconst dot-files-src
    (if load-file-name
	(file-name-directory load-file-name)
      (file-name-directory (buffer-file-name))))

  (defun bb/mkdir (target)
    "Verbose make dir"
    (if (not (file-directory-p target))
	(progn
	  (mkdir target)
	  (message "mkdir %s" target))))

  ;; create $HOME/.emacs.d and subdirectories
  (bb/mkdir (file-name-as-directory bb/emacs-directory))

  (dolist (subdir bb/emacs-subdirectories)
    (let ((source (concat (file-name-as-directory dot-files-src) subdir))
	  (destination (concat (file-name-as-directory bb/emacs-directory) subdir)))
      (unless (file-directory-p destination)
	(message "Copying %s %s" source destination)
	(copy-directory source destination))))

  (defun bb/tangle-file (file)
    "Given an 'org-mode' FILE, tangle the source code."
    (interactive "fOrg File: ")
    (message "tangling file %s" file)
    (find-file file)
    (org-babel-tangle)
    (kill-buffer))

  (dolist (orgfile (directory-files (concat dot-files-src "org") t "[.]org\\'"))
    (message "file is %s" orgfile)
    (bb/tangle-file orgfile))
)

(bb/build-dot-files)
