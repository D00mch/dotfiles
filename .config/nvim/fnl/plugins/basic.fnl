(local pc-with-rights? (os.getenv :OPENAI_API_KEY))

[{1 :bakpakin/fennel.vim
  :lazy true
  :ft [:fennel]}
 {1 :nvim-tree/nvim-web-devicons
  :config true}
 {1 :windwp/nvim-autopairs
  :opts {:disable_filetype
         [:clojure :scheme :lisp :timl :fennel :janet :racket]}
  :config true}
 {1 :tpope/vim-repeat}
 {1 :jghauser/follow-md-links.nvim
  :lazy true
  :ft [:markdown]}
 {1 :vim-scripts/ReplaceWithRegister}
 {1 :tpope/vim-sleuth}
 {1 :eandrju/cellular-automaton.nvim}
 {1 :famiu/bufdelete.nvim}
 {1 :kwkarlwang/bufresize.nvim
  :config true}
 {1 :tpope/vim-commentary}
 {1 :kevinhwang91/nvim-fundo
  :dependencies [:kevinhwang91/promise-async]
  :build (fn []
           (let [fundo (require :fundo)]
             (fundo.install)))
  :opts {}
  :config true}
 {1 :folke/which-key.nvim
  :lazy true
  :opts {:plugins        {:spelling    {:enabled false
                                        :suggestions 12}}
         :keys {:scroll_down :<right>
                :scroll_up   :<left>}}
  :config true}
 {1 :Exafunction/codeium.nvim
  :lazy (not pc-with-rights?)
  :config pc-with-rights?}]
