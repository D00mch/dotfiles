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

[{1 :NeogitOrg/neogit
  :dependencies [:nvim-lua/plenary.nvim]
  :init (fn []
          (kset [:n :x] :<Space>o neogit-toggle "Toggle NeoGit"))
  :cmd :Neogit
  :lazy true
  :opts {:kind :split
         :integrations {:diffview true
                        :telescope true}
         :disable_commit_confirmation true
         :sections {:untracked {:folded true}
                    :recent    {:folded true}}
         :mappings {:status {:o :Toggle
                             :q false}
                    :rebase_editor {:p false
                                    :r false
                                    :e false
                                    :s false
                                    :f false
                                    :x false
                                    :d false
                                    :b false
                                    :q false}}}
  :config true}]
