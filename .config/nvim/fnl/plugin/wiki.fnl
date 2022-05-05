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

(vim.api.nvim_create_autocmd 
  :BufWinEnter
  {:pattern :*.md
   :callback (fn [_] 
               (vim.cmd "silent! unmap <buffer> <Tab>") ;; do not use nvim_buf_del_keymap
               (vim.api.nvim_set_option_value :syntax :markdown {:scope :local})
               (vim.cmd "set wrap linebreak nolist"))})

;; insert markdown links
(u.m :n :<space>K "caw[]<Esc>hpla()<Esc>i")
(u.m :x :<space>K "<Esc>`>a](<C-r>*)<C-o>`<[<Esc>")

(u.m :n :<space>L "caw[]<Esc>hpla[]<Esc>i")
(u.m :x :<space>L "<Esc>`>a][<C-r>*]<C-o>`<[<Esc>")
