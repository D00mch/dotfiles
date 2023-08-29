(local {: autoload} (require :nfnl.module))
(local {: kset} (autoload :config.util))
(local {: merge} (autoload :nfnl.core))

(fn history-toggle []
  (let [current-dir (vim.fn.expand "%")
        in-annotate? (string.match current-dir "DiffviewFileHistoryPanel$")]
    (vim.api.nvim_command (if in-annotate? "q" "DiffviewFileHistory %"))))

[{1 :sindrets/diffview.nvim

  :init
  (fn []
    (kset [:n] :<space>gh history-toggle "Toggle git history")
    (kset [:x] :<space>gh ":DiffviewFileHistory<cr>" "Toggle git history")
    (kset [:n] :<space>gv ":DiffviewOpen"  "DiffviewOpen"))

  :config
  (fn []
    (let [dview (require :diffview)
          actions (require :diffview.actions)
          ufo (require :ufo)

          diffview-common-mappings
          {:gf actions.goto_file_edit
           :<Space>1 ":DiffviewToggleFiles<cr>"
           ::ggn actions.next_conflict
           ::ggp actions.prev_conflict}

          diffview-unmap
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
           :<esc> false}

          panel-mappings
          (merge 
            diffview-unmap
            diffview-common-mappings
            {:x actions.restore_entry
             :s actions.toggle_stage_entry})

          diff-keys
          [[[:n :x] :go (actions.conflict_choose :ours)]
           [[:n :x] :gt (actions.conflict_choose :theirs)]
           [[:n :x] :gb (actions.conflict_choose :base)]
           [[:n :x] :ga (actions.conflict_choose :all)]
           [[:n :x] :gn actions.next_conflict]
           [[:n :x] :gN actions.prev_conflict]]]
      (dview.setup
        {:view {:merge_tool {:layout "diff1_plain"}}
         :hooks {:diff_buf_read (fn [_] (ufo.detach))}
         :keymaps 
         {:disable_defaults   false
          :view               (merge 
                                diffview-unmap
                                diffview-common-mappings)
          :diff1              diff-keys              
          :diff3              diff-keys              
          :file_panel         panel-mappings
          :file_history_panel panel-mappings 
          :option_panel       panel-mappings}})))}]
