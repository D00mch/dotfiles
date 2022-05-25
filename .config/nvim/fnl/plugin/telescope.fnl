(module plugin.telescope
  {autoload {nvim aniseed.nvim
             telescope telescope
             themes telescope.themes
             actions telescope.actions
             fb_actions telescope._extensions.file_browser.actions
             pr_actions telescope._extensions.project.actions
             state telescope.actions.state
             mt telescope.actions.mt
             u util}})

(def- M (mt.transform_mod
          {:yank-entry 
           (fn [prompt_bufnr]
             (let [entry (state.get_selected_entry prompt_bufnr) ]
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
               :i {:≈       actions.close           ; alt+x
                   :?       actions.which_key 
                   :<Right> actions.preview_scrolling_down
                   :<Left>  actions.preview_scrolling_up
                   :∂       actions.delete_buffer   ; alt + d
                   :Ã·      actions.which_key}}}    ; alt + ?
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
                                           :h fb_actions.toggle_hidden}}}
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

(u.m :n :<space>pf ":Telescope find_files hidden=true no_ignore=false<cr>")
(u.m :n :<space>bb ":Telescope buffers sort_lastused=true show_all_buffers=false<cr>")
(u.m :n :<space>pa ":Telescope live_grep<cr>")
(u.m :n :<space>pp ":Telescope project display_type=minimal<cr>") ;; full
(u.m :n :<space>vm ":Telescope keymaps<cr>")
(u.m :n :<space>vc ":Telescope colorscheme<cr>")
(u.m :n :<space>ff ":Telescope file_browser<cr>")
(u.m :n :z= ":Telescope spell_suggest<cr>")

;; git
(u.m :n :<space>gc ":Telescope git_commits<cr>")
(u.m :n :<space>gs ":Telescope git_status<cr>")
(u.m :n :<space>gb ":Telescope git_branches<cr>")
