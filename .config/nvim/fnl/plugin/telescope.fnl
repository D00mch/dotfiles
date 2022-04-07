(module plugin.telescope
  {autoload {nvim aniseed.nvim
             telescope telescope
             u util}})

(telescope.setup 
  {:defaults
   {:vimgrep_arguments ["rg" "--color=never" "--no-heading"
                        "--with-filename" "--line-number" "--column"
                        "--smart-case" "--hidden" "--follow"
                        "-g" "!.git/"]}})


(u.m :n :<space>pf ":Telescope find_files hidden=true<cr>")
(u.m :n :<space>bb ":Telescope buffers<cr>")
(u.m :n :<space>pa ":Telescope live_grep<cr>")
(u.m :n :<space>pg ":Telescope live_grep<cr>")
(u.m :n :<space>vm ":Telescope keymaps<cr>")

