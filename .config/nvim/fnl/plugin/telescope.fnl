(module plugin.telescope
  {autoload {nvim aniseed.nvim
             telescope telescope
             themes telescope.themes
             actions telescope.actions
             fb_actions telescope._extensions.file_browser.actions
             pr_actions telescope._extensions.project.actions
             state telescope.actions.state
             mt telescope.actions.mt
             {: kset} util}})

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
    :layout_config {:height 0.9
                    :width 0.9}
    :layout_strategy :vertical ; cursor horizontal bottom_pane
    :wrap_results true
    :mappings {:n {:y       M.yank-entry
                   :<Right> actions.preview_scrolling_down
                   :<Left>  actions.preview_scrolling_up
                   :t       actions.select_tab}
               :i {:∑       actions.close           ; alt+x
                   :?       actions.which_key
                   :<Right> actions.preview_scrolling_down
                   :<Left>  actions.preview_scrolling_up
                   :∂       actions.delete_buffer   ; alt + d
                   :†       actions.select_tab      ; alt + t
                   :<D-t>   actions.select_tab
                   :Ã·      actions.which_key}}}    ; alt + ?
   :pickers {:git_branches {:mappings
                            {:n {:<Cr>  actions.git_switch_branch
                                 :ga    actions.git_create_branch
                                 :gh    actions.git_reset_hard
                                 :gs    actions.git_reset_soft
                                 :<D-m>   actions.git_merge_branch
                                 :gd    actions.git_delete_branch
                                 :gr    actions.git_rebase_branch}
                             :i {:<Cr>  actions.git_switch_branch
                                 :∂     actions.git_delete_branch  ; alt + d
                                 :<C-a> actions.git_create_branch
                                 :å     actions.git_create_branch  ; alt + a
                                 :<D-a> actions.git_create_branch
                                 :<C-h> actions.git_reset_hard
                                 :<C-s> actions.git_reset_soft
                                 :<C-m> actions.git_merge_branch
                                 :<C-b> actions.git_rebase_branch
                                 :<D-b> actions.git_rebase_branch
                                 :<C-r> actions.git_rebase_branch}}}
             :git_commits  {:mappings
                            {:n {:h actions.git_reset_hard}
                             :i {:<Cr> actions.git_checkout_current_buffer}}}}
   :extensions {:file_browser {:theme :ivy
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
                                           :≈ actions.close}}}
                :project {:base_dirs ["~/IdeaProjects"]
                          :mappings {:n ;; nerdtree-like mappings, doesn't work yet
                                     {:r pr_actions.rename_project
                                      :a pr_actions.add_project
                                      :<Cr> pr_actions.recent_project_files
                                      :o actions.select_default}}}
                :ui-select [(themes.get_dropdown {})]}})

;; after telescope setup
(telescope.load_extension :ui-select)
(telescope.load_extension :file_browser)
(telescope.load_extension :project)

(kset :n :<space>pf ":Telescope find_files hidden=true no_ignore=false<cr>")
(kset :n :<space>bb ":Telescope buffers sort_lastused=true show_all_buffers=false<cr>")
(kset :n :<space>pa ":Telescope live_grep<cr>")
(kset :n :<space>pp ":Telescope project display_type=minimal<cr>") ;; full
(kset :n :<space>vm ":Telescope keymaps<cr>")
(kset :n :<space>vc ":Telescope colorscheme<cr>")
(kset :n :<space>ff ":Telescope file_browser<cr>")
(kset :n :z= ":Telescope spell_suggest<cr>")

;; git
(kset :n :<space>gc ":Telescope git_commits<cr>")
(kset :n :<space>gs ":Telescope git_status<cr>")
(kset :n :<space>gb ":Telescope git_branches<cr>")

