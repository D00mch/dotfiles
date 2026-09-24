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

(fn describe-status-keys [buf]
  (when (vim.api.nvim_buf_is_valid buf)
    (vim.api.nvim_buf_call buf
      (fn []
        (let [wk (require :which-key)
              mappings (. (require :neogit.config) :values :mappings)
              labels {:Depth1 "Fold section"
                      :Depth2 "Show files in section"
                      :Depth3 "Show hunk headers in section"
                      :Depth4 "Show all changes in section"
                      :Toggle "Toggle fold"
                      :Command "Run Git command"
                      :VSplitOpen "Open in vertical split"}]
          ;; Follow Neogit's effective mappings, including remaps and disabled keys.
          (each [key action (pairs (vim.tbl_extend :force mappings.popup mappings.status
                                                  {:V "Select lines"}))]
            (when (= (type action) :string)
              (each [_ mode (ipairs [:n :x])]
                (when (= (. (vim.fn.maparg key mode false true) :buffer) 1)
                  (wk.add [{1 key :buffer buf :mode mode
                            :desc (or (. labels action)
                                      (action:gsub "(%l)(%u)" "%1 %2"))}])))))
          ;; Neogit installs this placeholder for disabled actions.
          (wk.add [{1 :<nop> :buffer buf :mode [:n :x] :hidden true}]))))))

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
                             :- false
                             :gr :Reverse
                             :v false
                             :q false}
                    :popup {:v false
                            :b false
                            :j false
                            :l false}
                    :rebase_editor {:p false
                                    :r false
                                    :e false
                                    :s false
                                    :f false
                                    :x false
                                    :d false
                                    :b false
                                    :q false}}}
  :config (fn [_ opts]
            ((. (require :neogit) :setup) opts)
            (vim.api.nvim_create_autocmd :FileType
              {:pattern :NeogitStatus
               :group (vim.api.nvim_create_augroup :NeogitKeyDescriptions {:clear true})
               :callback (fn [{: buf}]
                           ;; FileType fires before Neogit installs its keymaps.
                           (vim.schedule #(describe-status-keys buf)))}))}]
