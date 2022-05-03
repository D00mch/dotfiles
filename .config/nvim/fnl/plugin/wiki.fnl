(module plugin.wiki
  {require {nvim aniseed.nvim
            u util}
   require-macros [macros]})

(set nvim.g.vimwiki_list 
     [{:path "~/Yandex.Disk.localized/notes/wiki"
       :syntax "markdown"
       :ext ".md"}])

(set nvim.g.vimwiki_key_mappings {:table_mappings 0})

(set nvim.g.vimwiki_folding "custom")
(set nvim.g.vimwiki_global_ext 0)
(set nvim.g.vimwiki_map_prefix "<Leader>n")

(autocmd :BufWinEnter :*.md "setlocal syntax=markdown")
(autocmd :FileType :vimwiki "silent! unmap <buffer> <Tab>")

;; insert markdown links
(u.m :n :<space>K "caw[]<Esc>hpla()<Esc>i")
(u.m :x :<space>K "<Esc>`>a](<C-r>*)<C-o>`<[<Esc>")
