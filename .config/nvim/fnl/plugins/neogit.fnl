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

[{1 :TimUntersberger/neogit
  :dependencies [:nvim-lua/plenary.nvim]
  :init (fn []
          (kset [:n :x] :<Space>9 neogit-toggle "Toggle NeoGit"))

  :opts {:kind :split
         :integrations {:diffview true
                        :telescope true}
         :disable_commit_confirmation true
         :sections {:untracked {:folded true}
                    :recent    {:folded false}}
         :mappings {:status {:o :Toggle
                             :q false}}}
  :config true}]
