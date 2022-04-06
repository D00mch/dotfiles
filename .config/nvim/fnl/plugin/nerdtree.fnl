(module plugin.nerdtree
  {require {nvim aniseed.nvim
            ut   util}})

(set nvim.g.NERDTreeHijackNetrw 1)
(set nvim.g.NERDTreeShowHidden 1)

(nvim.ex.autocmd
      :VimEnter
      "NERD_tree_1"
      "enew | execute 'NERDTree '.argv()[0]")

(ut.nnoremap "<space>pt" ":NERDTreeFind<cr>")
(ut.nnoremap "¡" ":NERDTreeToggle")
