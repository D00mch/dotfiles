(module plugin
  {autoload {nvim aniseed.nvim
             a aniseed.core
             util util
             packer packer}})

(defn safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. :plugin. name))]
    (when (not ok?)
      (print (.. "fnl plugin error: " val-or-err)))))

(defn- use [...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (let [pkgs [...]]
    (packer.startup
      (fn [use]
        (for [i 1 (a.count pkgs) 2]
          (let [name (. pkgs i)
                opts (. pkgs (+ i 1))]
            (-?> (. opts :mod) (safe-require-plugin-config))
            (use (a.assoc opts 1 name)))))))
  nil)

(use
  ;; base
  :wbthomason/packer.nvim {}
  :Olical/aniseed {}
  :lewis6991/impatient.nvim {}

  ;; status line
  :kyazdani42/nvim-web-devicons {}
  :nvim-lualine/lualine.nvim {:mod :lualine }

  ;; repl
  :Olical/conjure {:branch :master :mod :conjure}

  ;; sexp
  :guns/vim-sexp {:mod :sexp}
  :tpope/vim-repeat {}
  :tpope/vim-surround {}

  ;; tree
  :preservim/nerdtree {:mod :nerdtree}
  :ryanoasis/vim-devicons {}

  ;; clojure
  :dense-analysis/ale {:mod :ale}

  ;; flutter
  :akinsho/flutter-tools.nvim {:requires [[:nvim-lua/plenary.nvim]]}

  ;; wiki
  :vimwiki/vimwiki {:mod :wiki :requires [[:xolox/vim-misc]]}

  ;; theme
  :sainnhe/everforest {:mod :theme}
  :arzg/vim-colors-xcode {}
  :cormacrelf/vim-colors-github {}
  :sainnhe/sonokai {}

  ;; telescope
  :nvim-telescope/telescope.nvim {:mod :telescope 
                                  :requires [[:nvim-lua/popup.nvim] 
                                             [:nvim-lua/plenary.nvim]]}

  ;; parsing system
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"
                                    :mod :treesitter}

  ;; lsp
  :neovim/nvim-lspconfig {:mod :lspconfig}

  ;; autocomplete
  :hrsh7th/nvim-cmp {:requires [:hrsh7th/cmp-buffer
                                :hrsh7th/cmp-nvim-lsp
                                :PaterJason/cmp-conjure]
                     :mod :cmp}

  :mhinz/vim-startify {:mod :startify}
  :ervandew/supertab {}
  :tpope/vim-commentary {}
  :jpalardy/vim-slime {:mod :slime}
  :tpope/vim-fugitive {}
  :vim-scripts/ReplaceWithRegister {}
  :jiangmiao/auto-pairs {:mod :auto-pairs}
  :mbbill/undotree {:mod :undotree}
  :airblade/vim-rooter {:mod :rooter}
  :ggandor/lightspeed.nvim {:mod :lightspeed})
