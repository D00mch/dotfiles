(module plugin.neogit
  {require {nvim aniseed.nvim
            dview diffview
            actions diffview.actions
            {: toggle} plugin.which
            neogit neogit
            {: kset} util}})

(neogit.setup
  {:kind :split
   :integrations {:diffview true}
   :disable_commit_confirmation true
   :sections {:untracked {:folded true}
              :recent    {:folded false}}
   :mappings {:status {:o :Toggle
                       :q "" }}})

(def toggle-files ::DiffviewToggleFiles<cr>)

(defn on-diffview [b]
  (kset [:n :i :x] :¡ toggle-files {:buffer b}) ;; alt+1, cmd+1
  (vim.api.nvim_buf_del_keymap b :n :<esc>))

(dview.setup
  {:hooks {:diff_buf_read on-diffview}
   :keymaps {:option_panel {:¡ toggle-files}
             :file_panel {:¡ toggle-files}}})

(defn neogit-toggle []
  (let [current-dir (vim.fn.expand "%") ;; :echo expand('%:p')
        in-git? (string.match current-dir "NeogitStatus$")
        diff-view? (string.match current-dir "^diffview://")]
    (vim.api.nvim_command (if
                            diff-view? "tabc"
                            in-git? "q"
                            "Neogit"))))

(vim.keymap.set [:n :x :i] :ª neogit-toggle) ;; alt+9, (mapped to cmd+9 with karabiner)
(kset [:i] :ª "<Esc>ª" {:noremap false})     ;; alt+9

(defn annotate-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "fugitiveblame$")]
    (vim.api.nvim_command (if in-annotate? "q" "G blame"))))

(kset [:n :x] :<space>ga annotate-toggle)

(defn history-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "DiffviewFileHistoryPanel$")]
    (vim.api.nvim_command (if in-annotate? "q" "DiffviewFileHistory %"))))

(kset [:n] :<space>gh history-toggle)
(kset [:x] :<space>gh ":DiffviewFileHistory<cr>" {:noremap false})

(set nvim.g.gitgutter_map_keys 0)
(set nvim.g.gitgutter_enabled 0)
(toggle "g" "GitGutterToggle" ::GitGutterToggle<cr>)
(kset [:n :x] :gs ::GitGutterStageHunk<cr> {})

;; code in case they don't approve my pr https://github.com/TimUntersberger/neogit/pull/375
; (def group (vim.api.nvim_create_augroup :MyCustomNeogitEvents {:clear true}))
; (vim.api.nvim_create_autocmd
;   :User
;   {:pattern :NeogitStatusRefreshed
;    :group   group
;    :callback (fn [] (util.bm "" :q "<Plug>(leap-forward)" {:noremap false}))})
