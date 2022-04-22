(module plugin.nerdtree
  {require {nvim aniseed.nvim
            str aniseed.string
            core aniseed.core
            u aniseed.nvim.util
            util util}
   require-macros [macros]})

(set nvim.g.NERDTreeHijackNetrw 1)
(set nvim.g.NERDTreeShowHidden 1)
(set nvim.g.NERDTreeCustomOpenArgs {:file {:keepopen 0}})

(autocmd :VimEnter :NERD_tree_1 "enew | execute 'NERDTree '.argv()[0]")

(util.nmap "¡" ":NERDTreeToggle<cr>") ; alt+1
(util.m :i "¡" "<Esc>¡" {:noremap false})

(util.nmap "<space>pt" ":NERDTreeFindOrOpen<cr>")

(vim.api.nvim_create_user_command
  :NERDTreeFindOrOpen
  (fn [args]
    (let [empty? (str.blank? (vim.fn.expand "%"))]
      (vim.api.nvim_command (if empty? "NERDTree" "NERDTreeFind"))))
  {:nargs :* :desc "Open nerdtree even from startify"})
