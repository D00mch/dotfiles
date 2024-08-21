(local {: autoload} (require :nfnl.module))
(local
  {: kset : get-word-under-cursor : get-word-under-selection}
  (autoload :config.util))

[{1 :nvim-telescope/telescope.nvim
  :dependencies [:nvim-lua/popup.nvim
                 :nvim-lua/plenary.nvim
                 :nvim-telescope/telescope-ui-select.nvim
                 :ahmedkhalf/project.nvim
                 :debugloop/telescope-undo.nvim
                 :nvim-telescope/telescope-file-browser.nvim
                 :mollerhoj/telescope-recent-files.nvim
                 ; :RomanoZumbe/harpoon
                 ]
  :lazy true
  :init (fn []
          ; (let [hmark (require :harpoon.mark)]
          ;   (kset :n :<Space>am hmark.add_file "Add mark"))

          (kset :n :<space>pf ":Telescope find_files hidden=true no_ignore=false<cr>")
          (kset :n :<space>pr ":Telescope pickers<cr>")
          (kset :n :<space>pb ":Telescope buffers sort_lastused=true show_all_buffers=false<cr>")
          (kset :n :<space>pa ":Telescope live_grep<cr>")
          (kset :n :<space>pp ":Telescope projects<cr>" "Projects")
          (kset :n :<space>ph ":Telescope harpoon marks<cr>" "Harpoon")
          (kset :n :<space>pu ":Telescope undo<Cr>" "Undo")
          ;(kset :n :<space>pq ":Telescope quickfix<cr>" "QuickFix")

          (kset :n :<space>vk ":Telescope keymaps<cr>")
          (kset :n :<space>vc ":Telescope colorscheme<cr>")
          (kset :n :<space>v: ":Telescope commands<cr>")
          (kset :n :<space>vo ":Telescope vim_options<cr>")
          (kset :n :<space>vm ":Telescope marks<cr>")
          (kset :n :<space>vr ":Telescope registers<cr>")

          (kset :n :z= ":Telescope spell_suggest<cr>")

          ;; git
          (kset :n :<space>gc ":Telescope git_commits<cr>")
          (kset :n :<space>gs ":Telescope git_stash<cr>")
          (kset :n :<space>gb ":Telescope git_branches<cr>")

          (let [;; search for a word under cursor
                builtin (require :telescope.builtin)
                search-word-under-cursor
                (fn []
                  (let [[word] (get-word-under-cursor)]
                    (builtin.live_grep {:default_text word})))

                search-word-under-selection
                (fn []
                  (let [[word] (get-word-under-selection)]
                    (builtin.live_grep {:default_text word})))]
            (kset :n :<Leader>gr search-word-under-cursor))
          
          (let [telescope (require :telescope)]
            (telescope.load_extension "ui-select")
            (telescope.load_extension :ui-select)
            (telescope.load_extension :file_browser)
            (telescope.load_extension :projects)
            (telescope.load_extension :recent-files)
            ;(telescope.load_extension :harpoon)
            (telescope.load_extension :undo)))

  :config (fn []
            (let [telescope (require :telescope)
                  themes (require :telescope.themes)
                 ; harpoon (require :harpoon)
                  prj (require :project_nvim)
                  actions (require :telescope.actions)
                  undo_actions (require :telescope-undo.actions)
                  state (require :telescope.actions.state)
                  mt (require :telescope.actions.mt)

                  ;; visually select a file path
                  ;; source: https://github.com/drybalka/dotfiles/blob/main/.config/nvim/lua/common/telescope.lua#L173-L202

                  M (mt.transform_mod
                      {:yank-entry
                       (fn [prompt_bufnr]
                         (let [entry (state.get_selected_entry prompt_bufnr)]
                           (vim.fn.setreg "*" entry.value)
                           (actions.close prompt_bufnr)))})]

              (kset :n :<space>b
                    #((. (. telescope.extensions :recent-files) :recent_files) {})	                
                    "search files with priority to recent")

              ;(harpoon.setup)
              (prj.setup
                {:patterns [".git" "package.json" "deps.edn" "project.clj"]})


              (telescope.setup
                {:defaults
                 {:vimgrep_arguments ["rg" "--color=never" "--no-heading"
                                      "--with-filename" "--line-number" "--column"
                                      "--smart-case" "--hidden" "--follow"
                                      "-g" "!.git/" "-g" "!.clj-kondo/"]
                  :cache_picker {:num_pickers 10}
                  :layout_config {:height 0.9
                                  :width 0.9}
                  :layout_strategy :vertical ; cursor horizontal bottom_pane
                  :wrap_results true
                  :mappings {:n {:y       M.yank-entry
                                 :<Esc>   false
                                 :<D-w>   actions.close
                                 :<Right> actions.preview_scrolling_down
                                 :<Left>  actions.preview_scrolling_up
                                 :t       actions.select_tab
                                 ;:<D-t>   actions.select_tab
                                 :q       (+ actions.smart_send_to_qflist actions.open_qflist)}
                             :i {:<M-x>   actions.close
                                 :<C-q>   (+ actions.smart_send_to_qflist actions.open_qflist)
                                 :?       actions.which_key
                                 :<Right> actions.preview_scrolling_down
                                 :<Left>  actions.preview_scrolling_up
                                 :<M-d>   actions.delete_buffer
                                 :<M-t>   actions.select_tab
                                 ;:<D-t>   actions.select_tab
                                 :<M-?>   actions.which_key
                                 :<C-u>   false}}}
                 :pickers {:git_branches        {:mappings
                                                 {:n {:<Cr>  actions.git_switch_branch
                                                      :ga    actions.git_create_branch
                                                      :gh    actions.git_reset_hard
                                                      :gs    actions.git_reset_soft
                                                      :<D-m> actions.git_merge_branch
                                                      :gd    actions.git_delete_branch
                                                      :gr    actions.git_rebase_branch}
                                                  :i {:<Cr>  actions.git_switch_branch
                                                      :<M-d> actions.git_delete_branch
                                                      :<C-a> actions.git_create_branch
                                                      :<M-a> actions.git_create_branch
                                                      :<D-a> actions.git_create_branch
                                                      :<C-h> actions.git_reset_hard
                                                      :<C-s> actions.git_reset_soft
                                                      :<C-m> actions.git_merge_branch
                                                      :<C-b> actions.git_rebase_branch
                                                      :<D-b> actions.git_rebase_branch
                                                      :<C-r> actions.git_rebase_branch}}}
                           :git_commits         {:mappings
                                                 {:n {:h     actions.git_reset_hard
                                                      :<Esc> false}
                                                  :i {:<Cr> actions.git_checkout_current_buffer}}}
                           :buffers             {:sort_mru true}
                           :live_grep           {:only_sort_text  true
                                                 :additional_args ["--trim"]}}
                 :extensions {:undo {:mappings {:n {:y undo_actions.yank_additions
                                                    :Y undo_actions.yank_deletions}}}
                              :ui-select [(themes.get_cursor {})]
                              :frecency {:ignore_patterns  ["*/.git" "*/.git/*" "*/.DS_Store"]
                                         :db_safe_mode false}}})))}]
