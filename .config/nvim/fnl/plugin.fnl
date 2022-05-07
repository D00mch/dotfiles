(module plugin
  {autoload {nvim aniseed.nvim
             util util
             packer packer}
   require {{: assoc : count} aniseed.core}})

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
        (for [i 1 (count pkgs) 2]
          (let [name (. pkgs i)
                opts (. pkgs (+ i 1))]
            (-?> (. opts :mod) (safe-require-plugin-config))
            (use (assoc opts 1 name)))))))
  nil)

(use
  ;; base
  :wbthomason/packer.nvim {}
  :Olical/aniseed {}
  :lewis6991/impatient.nvim {}

  ;; status line
  :kyazdani42/nvim-web-devicons {}
  :nvim-lualine/lualine.nvim {:mod :lualine}

  ;; repl
  :Olical/conjure {:branch :master :mod :conjure}

  ;; sexp
  :guns/vim-sexp {:mod :sexp}
  :tpope/vim-repeat {}
  :tpope/vim-surround {}

  ;; tree
  :preservim/nerdtree {:mod :nerdtree}
  :ryanoasis/vim-devicons {}

  ;; flutter
  :akinsho/flutter-tools.nvim {:requires [[:nvim-lua/plenary.nvim]]}

  ;; writing
  :vimwiki/vimwiki {:mod :wiki 
                    :ft [:markdown]
                    :requires [:xolox/vim-misc
                               :preservim/vim-textobj-sentence
                               :preservim/vim-textobj-quote ;; depends on below
                               :kana/vim-textobj-user]}

  ;; theme
  :EdenEast/nightfox.nvim {:mod :theme}
  :sainnhe/everforest {}
  :cormacrelf/vim-colors-github {}
  :sainnhe/sonokai {}

  ;; telescope
  :nvim-telescope/telescope.nvim {:mod :telescope 
                                  :requires [[:nvim-lua/popup.nvim] 
                                             [:nvim-lua/plenary.nvim]
                                             [:nvim-telescope/telescope-ui-select.nvim]]}

  ;; parsing system
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"
                                    :requires [[:p00f/nvim-ts-rainbow]]
                                    :mod :treesitter}

  ;; lsp
  :neovim/nvim-lspconfig {:mod :lspconfig
                          :requires [:williamboman/nvim-lsp-installer]}

  ;; autocomplete
  :hrsh7th/nvim-cmp {:requires [:hrsh7th/cmp-buffer
                                :hrsh7th/cmp-nvim-lsp
                                :hrsh7th/cmp-path
                                :hrsh7th/cmp-cmdline
                                :L3MON4D3/LuaSnip
                                :f3fora/cmp-spell
                                :saadparwaiz1/cmp_luasnip
                                :PaterJason/cmp-conjure]
                     :mod :cmp}

  :gcmt/taboo.vim {}
  :qpkorr/vim-bufkill {}
  :akinsho/toggleterm.nvim {:mod :toggleterm}
  :mhinz/vim-startify {:mod :startify}
  :tpope/vim-commentary {}
  :jpalardy/vim-slime {:mod :slime}
  :tpope/vim-fugitive {:mod :fugitive}
  :vim-scripts/ReplaceWithRegister {}
  :jiangmiao/auto-pairs {:mod :auto-pairs}
  :mbbill/undotree {:mod :undotree}
  :airblade/vim-rooter {:mod :rooter}
  :folke/which-key.nvim {:mod :which}
  :ggandor/lightspeed.nvim {:mod :lightspeed})
