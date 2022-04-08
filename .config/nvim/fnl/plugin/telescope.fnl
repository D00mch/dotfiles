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
                        "-g" "!.git/"]
    :layout_config {:height 0.9
                    :width 0.9}
    :layout_strategy :vertical ; cursor horizontal bottom_pane
    :wrap_results true
    :mappings {:i {:<esc> actions.close}}}})


(u.m :n :<space>pf ":Telescope find_files hidden=true<cr>")
(u.m :n :<space>bb ":Telescope buffers<cr>")
(u.m :n :<space>pa ":Telescope live_grep<cr>")
(u.m :n :<space>pg ":Telescope live_grep<cr>")
(u.m :n :<space>vm ":Telescope keymaps<cr>")

