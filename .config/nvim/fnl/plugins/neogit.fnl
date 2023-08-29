(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))

(fn neogit-toggle []
  (let [current-dir (vim.fn.expand "%") ;; :echo expand('%:p')
        in-git? (string.match current-dir "NeogitStatus$")
        diff-view? (string.match current-dir "^diffview://")]
    (vim.api.nvim_command (if
                            diff-view? "tabc"
                            in-git? "bd"
                            "Neogit"))))

[]
; [{1 :TimUntersberger/neogit
;   :lazy true
;   :ft [:no-such-a-filetype]

;   :init (fn []
;           (kset [:n :x] :<Space>9 neogit-toggle "Toggle NeoGit"))

;   :opts {:kind :replace
;          :integrations {:diffview true}
;          :disable_commit_confirmation true
;          :sections {:untracked {:folded true}
;                     :recent    {:folded false}}
;          :mappings {:status {:o :Toggle
;                              :q ""}}}
;   :config true}]
