(module plugin.telescope
  {autoload {nvim aniseed.nvim
             telescope telescope
             actions telescope.actions
             u util}})

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
    :mappings {:i {:<Esc>   actions.close
                   :<Right> actions.preview_scrolling_down
                   :<Left>  actions.preview_scrolling_up
                   :∂       actions.delete_buffer   ; alt + d
                   :Ã·      actions.which_key}}}})  ; alt + ?                   

(u.m :n :<space>pf ":Telescope find_files hidden=true no_ignore=false<cr>")
(u.m :n :<space>bb ":Telescope buffers sort_lastused=true<cr>")
(u.m :n :<space>pa ":Telescope live_grep<cr>")
(u.m :n :<space>pg ":Telescope git_commits<cr>")
(u.m :n :<space>vm ":Telescope keymaps<cr>")
(u.m :n :<space>vc ":Telescope colorscheme<cr>")
