(local pc-with-rights? (os.getenv :OPENAI_API_KEY))

[{1 :bakpakin/fennel.vim
  :lazy true
  :ft [:fennel]}
 {1 :nvim-tree/nvim-web-devicons
  :event :VeryLazy
  :config true}
 {1 :windwp/nvim-autopairs
  :event :VeryLazy
  :opts {:disable_filetype
         [:clojure :scheme :lisp :timl :fennel :janet :racket]}
  :config true}
 {1 :tpope/vim-repeat
  :event :VeryLazy}
 {1 :jghauser/follow-md-links.nvim
  :lazy true
  :ft [:markdown]}
 {1 :vim-scripts/ReplaceWithRegister 
  :event :VeryLazy}
 {1 :eandrju/cellular-automaton.nvim 
  :event :VeryLazy}
 {1 :famiu/bufdelete.nvim
  :event :VeryLazy}
 {1 :kwkarlwang/bufresize.nvim
  :config true}
 {1 :tpope/vim-commentary
  :event :VeryLazy}
 {1 :kevinhwang91/nvim-fundo
  :dependencies [:kevinhwang91/promise-async]
  :build (fn []
           (let [fundo (require :fundo)]
             (fundo.install)))
  :opts {}
  :config true}
 {1 :folke/which-key.nvim
  :lazy true
  :event :VeryLazy
  :opts {:plugins        {:spelling    {:enabled false
                                        :suggestions 12}}
         :keys {:scroll_down :<right>
                :scroll_up   :<left>}}
  :config true}
 {1 :Exafunction/codeium.nvim
  :cond pc-with-rights? 
  :event :VeryLazy
  :config false}
 {1 :dstein64/vim-startuptime
  :lazy true
  :cmd :StartupTime}

 ;;colorschemes
 {1 :rose-pine/neovim
  :lazy true
  :keys [[:<Space>vc :n]]}
 {1 :neanias/everforest-nvim
  :lazy true
  :keys [[:<Space>vc :n]]
  :config true
  :opts {:background :hard}}
 {1 :rebelot/kanagawa.nvim
  :lazy true
  :keys [[:<Space>vc :n]]}]
