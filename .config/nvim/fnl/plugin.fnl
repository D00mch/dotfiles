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
  :kyazdani42/nvim-tree.lua {:mod :tree}
  :ryanoasis/vim-devicons {}

  ;; flutter
  :akinsho/flutter-tools.nvim {:requires [[:nvim-lua/plenary.nvim]]}

  ;; writing
  :jghauser/follow-md-links.nvim {:mod :markdown }
  :preservim/vim-textobj-sentence {:ft [:markdown]}
  :preservim/vim-textobj-quote {:ft [:markdown]
                                :requires [:kana/vim-textobj-user]}
  :uga-rosa/translate.nvim {:mod :translate}

  ;; theme
  :EdenEast/nightfox.nvim {:mod :theme}
  :sainnhe/everforest {}
  :cormacrelf/vim-colors-github {}
  :sainnhe/sonokai {}

  ;; telescope
  :nvim-telescope/telescope.nvim {:mod :telescope 
                                  :requires [[:nvim-lua/popup.nvim] 
                                             [:nvim-lua/plenary.nvim]
                                             [:nvim-telescope/telescope-ui-select.nvim]
                                             [:nvim-telescope/telescope-project.nvim]
                                             [:nvim-telescope/telescope-file-browser.nvim]]}

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
                                :f3fora/cmp-spell
                                :PaterJason/cmp-conjure]
                     :mod :cmp}
  :dcampos/nvim-snippy {:requires [:dcampos/cmp-snippy]}

  :svban/YankAssassin.vim {}
  :chrisbra/Colorizer {:mod :colors}
  :gcmt/taboo.vim {}
  :qpkorr/vim-bufkill {}
  :akinsho/toggleterm.nvim {:mod :terminal}
  :mhinz/vim-startify {:mod :startify}
  :tpope/vim-commentary {}
  :tpope/vim-fugitive {:mod :fugitive}
  :vim-scripts/ReplaceWithRegister {}
  :jiangmiao/auto-pairs {:mod :auto-pairs}
  :mbbill/undotree {:mod :undotree}
  :airblade/vim-rooter {:mod :rooter}
  :folke/which-key.nvim {:mod :which}
  :ggandor/lightspeed.nvim {:mod :lightspeed})
