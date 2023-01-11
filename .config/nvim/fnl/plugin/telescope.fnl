(module plugin.telescope
  {autoload {nvim aniseed.nvim
             telescope telescope
             harpoon harpoon
             hmark harpoon.mark
             themes telescope.themes
             actions telescope.actions
             fb_actions telescope._extensions.file_browser.actions
             undo_actions telescope-undo.actions
             prj project_nvim
             state telescope.actions.state
             mt telescope.actions.mt
             {: kset} util}})

(harpoon.setup)
(kset :n :<Space>am hmark.add_file "Add mark")

(prj.setup
  {:patterns [".git" "package.json" "deps.edn" "project.clj"]})

(def- M (mt.transform_mod
          {:yank-entry
           (fn [prompt_bufnr]
             (let [entry (state.get_selected_entry prompt_bufnr)]
               (vim.fn.setreg "*" entry.value)
               (actions.close prompt_bufnr)))}))

(telescope.setup
  {:defaults
   {:vimgrep_arguments ["rg" "--color=never" "--no-heading"
                        "--with-filename" "--line-number" "--column"
                        "--smart-case" "--hidden" "--follow"
                        "-g" "!.git/" "-g" "!.clj-kondo/"]
    :cache_picker {:num_pickers 3}
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
                   :<M-?>   actions.which_key}}}
   :pickers {:git_branches {:mappings
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
             :git_commits  {:mappings
                            {:n {:h actions.git_reset_hard
                                 :<Esc> false}
                             :i {:<Cr> actions.git_checkout_current_buffer}}}
             :live_grep {:only_sort_text true}}
   :extensions {:undo {:mappings {:n {:y undo_actions.yank_additions
                                      :Y undo_actions.yank_deletions}}}
                :file_browser {:theme :ivy
                               :mappings {:n
                                          {:u fb_actions.goto_parent_dir
                                           :f fb_actions.open
                                           :a fb_actions.create
                                           :o actions.select_default
                                           :r fb_actions.rename
                                           :m fb_actions.move ;; several items
                                           :c fb_actions.copy
                                           :d fb_actions.remove
                                           :h fb_actions.toggle_hidden
                                           :H fb_actions.goto_cwd
                                           :<Esc> false
                                           :<M-w> actions.close}}}
                :ui-select [(themes.get_cursor {})]}})

;; after telescope setup
(telescope.load_extension :ui-select)
(telescope.load_extension :file_browser)
(telescope.load_extension :projects)
(telescope.load_extension :harpoon)
(telescope.load_extension :undo)

(kset :n :<space>pf ":Telescope find_files hidden=true no_ignore=false<cr>")
(kset :n :<space>pr ":Telescope pickers<cr>")
(kset :n :<space>bb ":Telescope buffers sort_lastused=true show_all_buffers=false<cr>")
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
