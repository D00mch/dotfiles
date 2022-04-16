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
(util.nmap "<space>pt" ":call NERDTreeFindOrOpen()<cr>")

(defn find-or-open []
  (let [empty? (str.blank? (vim.fn.expand "%"))]
    (vim.cmd (if empty? "NERDTree" "NERDTreeFind"))))

(u.fn-bridge :NERDTreeFindOrOpen :plugin.nerdtree :find-or-open)
