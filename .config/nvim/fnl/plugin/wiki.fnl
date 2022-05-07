(module plugin.wiki
  {require {nvim aniseed.nvim
            {: toggle} plugin.which
            u util}
   require-macros [macros]})

(set nvim.g.vimwiki_list 
     [{:path "~/Yandex.Disk.localized/notes/wiki"
       :syntax "markdown"
       :ext ".md"}])

(set nvim.g.vimwiki_key_mappings {:table_mappings 1})
(set nvim.g.vimwiki_folding "custom")
(set nvim.g.vimwiki_global_ext 0)
(set nvim.g.vimwiki_map_prefix "<Leader>n")

(defn setup-quote []
  (vim.cmd "call textobj#quote#init({'educate':0})")
  (toggle "q" "auto quotes" ":ToggleEducate<Cr>" 0))

(defn setup-pensil []
  (vim.api.nvim_set_option_value :formatoptions :t {:scope :local})
  (vim.api.nvim_set_option_value :textwidth 80 {:scope :local})
  (u.bm :x := "gq"))

(defn setup-wiki []
  (vim.cmd "silent! unmap <buffer> <Tab>") ;; do not use nvim_buf_del_keymap
  (vim.cmd "set wrap linebreak nolist")    ;; hard wrap without bracking a word
  (vim.api.nvim_set_option_value :syntax :markdown {:scope :local})
  (vim.api.nvim_set_option_value :filetype :markdown {:scope :local}))

(defn setup-md []
  (setup-wiki)
  (setup-pensil)
  (setup-quote)

  ;; insert markdown links
  (u.bm :n :<space>K "caw[]<Esc>hpla()<Esc>i")
  (u.bm :x :<space>K "<Esc>`>a](<C-r>*)<C-o>`<[<Esc>")
  (u.bm :n :<space>L "caw[]<Esc>hpla[]<Esc>i")
  (u.bm :x :<space>L "<Esc>`>a][<C-r>*]<C-o>`<[<Esc>"))

(vim.api.nvim_create_autocmd
  :Filetype
  {:pattern :vimwiki
   :callback setup-md})

(vim.api.nvim_create_autocmd
  :BufWinEnter
  {:pattern :*.md
   :callback setup-md})
