(module plugin.neogit
  {require {nvim aniseed.nvim
            gs gitsigns
            dview diffview
            actions diffview.actions
            {: merge} aniseed.core
            {: toggle} plugin.which
            neogit neogit
            {: kset : bkset : vis-op} util}})

;;; diffview

(def diffview-common-mappings
  {:gf actions.goto_file_tab
   :<Space>1 ":DiffviewToggleFiles<cr>"
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
   :q false
   :<esc> false})

(def panel-mappings
  (merge 
    diffview-unmap
    diffview-common-mappings
    {:x actions.restore_entry
     :s actions.toggle_stage_entry}))

(dview.setup
  {:keymaps 
   {:disable_defaults   false
    :view               (merge 
                          diffview-unmap
                          diffview-common-mappings)
    :diff3              [[[:n :x] :go (actions.conflict_choose "ours")]
                         [[:n :x] :gt (actions.conflict_choose "theirs")]
                         [[:n :x] :gb (actions.conflict_choose "base")]
                         [[:n :x] :ga (actions.conflict_choose "all")]
                         [[:n :x] :gn actions.next_conflict]
                         [[:n :x] :gp actions.prev_conflict]]
    :file_panel         panel-mappings
    :file_history_panel panel-mappings 
    :option_panel       panel-mappings}})

(defn history-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "DiffviewFileHistoryPanel$")]
    (vim.api.nvim_command (if in-annotate? "q" "DiffviewFileHistory %"))))

(kset [:n] :<space>gh history-toggle "Toggle git history")
(kset [:x] :<space>gh ":DiffviewFileHistory<cr>" "Toggle git history")
(kset [:n] :<space>gv ":DiffviewOpen"  "DiffviewOpen")

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

(kset [:n :x] :<Space>9 neogit-toggle "Toggle NeoGit")

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
                             :delay 1000}
   :on_attach
   (fn [b]
     (bkset :n :gn (fn [] (vim.schedule gs.next_hunk)) {:buffer b :desc "Gitsigns next"})
     (bkset :n :gp (fn [] (vim.schedule gs.prev_hunk)) {:buffer b :desc "Gitsigns prev"})
     (bkset :n :gs gs.stage_hunk {:buffer b :desc "Gitsigns stage hunk"})
     (bkset :x :gs (vis-op gs.stage_hunk) {:buffer b :desc "Gitsigns stage hunk"})

     (bkset :n :<Space>gS (fn [] (vim.schedule gs.stage_buffer)) {:buffer b :desc "Gitsigns stage buffer"})
     (bkset :n :<Space>gr gs.reset_hunk {:buffer b :desc "Gitsigns stage hunk"})
     (bkset :x :<Space>gr (vis-op gs.reset_hunk) {:buffer b :desc "Gitsigns stage hunk"})
     (bkset :n :<Space>gu gs.undo_stage_hunk {:buffer b :desc "Gitsigns undo staged"})
     (bkset :n :<Space>gm (fn [] (gs.blame_line {:full true})) {:buffer b :desc "Gitsigns blame message"})
     (bkset :n :<Space>gl (fn [] (gs.toggle_current_line_blame)) {:buffer b :desc "Gitsigns blame line"})
     (bkset :n :<Space>gd gs.diffthis {:buffer b :desc "Gitsigns diff"})

     ;; toggle
     (toggle :g "gitsigns" gitsigns)
     (bkset :n :<Space>gt gitsigns))})

;; code in case they don't approve my pr https://github.com/TimUntersberger/neogit/pull/375
; (def group (vim.api.nvim_create_augroup :MyCustomNeogitEvents {:clear true}))
; (vim.api.nvim_create_autocmd
;   :User
;   {:pattern :NeogitStatusRefreshed
;    :group   group
;    :callback (fn [] (util.bm "" :q "<Plug>(leap-forward)" {:noremap false}))})
