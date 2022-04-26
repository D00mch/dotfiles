(module plugin.telescope
  {autoload {nvim aniseed.nvim
             telescope telescope
             actions telescope.actions
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
                   :t       actions.select_tab}
               :i {:≈       actions.close           ; alt+x
                   :?       actions.which_key 
                   :<Right> actions.preview_scrolling_down
                   :<Left>  actions.preview_scrolling_up
                   :∂       actions.delete_buffer   ; alt + d
                   :Ã·      actions.which_key}}}})  ; alt + ?                   

(u.m :n :<space>pf ":Telescope find_files hidden=true no_ignore=false<cr>")
(u.m :n :<space>bb ":Telescope buffers sort_lastused=true show_all_buffers=false<cr>")
(u.m :n :<space>pa ":Telescope live_grep<cr>")
(u.m :n :<space>vm ":Telescope keymaps<cr>")
(u.m :n :<space>vc ":Telescope colorscheme<cr>")

;; git
(u.m :n :<space>gc ":Telescope git_commits<cr>")
(u.m :n :<space>gs ":Telescope git_status<cr>")
(u.m :n :<space>gb ":Telescope git_branches<cr>")

