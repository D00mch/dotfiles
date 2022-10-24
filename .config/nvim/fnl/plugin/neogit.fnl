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

(dview.setup
  {:hooks {:diff_buf_read
           (fn [b]
             ;; alt+1, cmd+1
             (kset [:n :i :x] :¡ ::DiffviewToggleFiles<cr> {:buffer b})
             (vim.api.nvim_buf_del_keymap b :n :<esc>))}
   :keymaps {:option_panel {}
             :file_panel {}}})

; (string.match "diffview://" "^diffview://")

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
        in-annotate? (string.match current-dir "DiffviewFileHistoryPanel$")]
    (vim.api.nvim_command (if in-annotate? "q" "DiffviewFileHistory %"))))

(vim.keymap.set [:n] :<space>ga annotate-toggle)
(kset [:x] :<space>ga ":DiffviewFileHistory<cr>" {:noremap false})

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
