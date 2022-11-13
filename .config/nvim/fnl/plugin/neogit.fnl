(module plugin.neogit
  {require {nvim aniseed.nvim
            gs gitsigns
            dview diffview
            actions diffview.actions
            {: merge} aniseed.core
            {: toggle} plugin.which
            neogit neogit
            {: kset : bkset} util}})

(def toggle-files ::DiffviewToggleFiles<cr>)

(defn on-diffview [b]
  (kset [:n :i :x] :¡ toggle-files {:buffer b}) ;; alt+1, cmd+1
  (vim.api.nvim_buf_del_keymap b :n :<esc>))

(def diffview-common-mappings
  {:gf actions.goto_file_tab
   :¡ toggle-files
   ::ggn actions.next_conflict
   ::ggp actions.prev_conflict})

(def diffview-unmap
  {:<leader>e false
   :<leader>b false
   :<leader>co false
   :<leader>ct false
   :<leader>cb false
   :<leader>ca false
   "[x" false
   "]x" false
   :dx false
   :q false})

(def panel-mappings
  (merge 
    diffview-unmap
    diffview-common-mappings
    {:x actions.restore_entry
     :s actions.toggle_stage_entry}))

(dview.setup
  {:hooks {:diff_buf_read on-diffview}
   :keymaps 
   {:disable_defaults   false
    :view               (merge 
                          diffview-unmap
                          diffview-common-mappings)
    :diff3              [[[:n :x] :ggo (actions.conflict_choose "ours")]
                         [[:n :x] :ggt (actions.conflict_choose "theirs")]
                         [[:n :x] :ggb (actions.conflict_choose "base")]
                         [[:n :x] :gga (actions.conflict_choose "all")]
                         [[:n :x] :ggn actions.next_conflict]
                         [[:n :x] :ggp actions.prev_conflict]]
    :file_panel         panel-mappings
    :file_history_panel panel-mappings 
    :option_panel       panel-mappings}})

(defn history-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "DiffviewFileHistoryPanel$")]
    (vim.api.nvim_command (if in-annotate? "q" "DiffviewFileHistory %"))))

(kset [:n] :<space>gh history-toggle)
(kset [:x] :<space>gh ":DiffviewFileHistory<cr>" {:noremap false})

;;; neogit

(neogit.setup
  {:kind :split
   :integrations {:diffview true}
   :disable_commit_confirmation true
   :sections {:untracked {:folded true}
              :recent    {:folded false}}
   :mappings {:status {:o :Toggle
                       :q "" }}})

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

;;; fugitive

(defn annotate-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "fugitiveblame$")]
    (vim.api.nvim_command (if in-annotate? "q" "G blame"))))

(kset [:n :x] :<space>ga annotate-toggle)

;;; gitsigns

(defn gitsigns []
  (gs.toggle_linehl)
  (gs.toggle_word_diff))

(gs.setup
  {:signcolumn false
   :numhl      true
   :current_line_blame_opts {:overlay true
                             :delay 300}
   :on_attach
   (fn [b]
     (bkset :n :gn (fn [] (vim.schedule gs.next_hunk)) b)
     (bkset :n :gp (fn [] (vim.schedule gs.prev_hunk)) b)
     (bkset [:n :x] :gs gs.stage_hunk b)
     (bkset :n :gus gs.undo_stage_hunk b)
     (bkset :n :gb (fn [] (gs.blame_line {:full true})) b)
     (bkset :n :gl (fn [] (gs.toggle_current_line_blame)) b)

     ;; preview
     (bkset :n :gD gs.diffthis b)
     (bkset :n :gM (fn [] (gs.diffthis "~")) b)

     ;; toggle
     (toggle :g "gitsigns" gitsigns)
     (bkset :n :gt gitsigns))})

;; code in case they don't approve my pr https://github.com/TimUntersberger/neogit/pull/375
; (def group (vim.api.nvim_create_augroup :MyCustomNeogitEvents {:clear true}))
; (vim.api.nvim_create_autocmd
;   :User
;   {:pattern :NeogitStatusRefreshed
;    :group   group
;    :callback (fn [] (util.bm "" :q "<Plug>(leap-forward)" {:noremap false}))})
