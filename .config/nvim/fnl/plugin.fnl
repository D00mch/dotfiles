(module plugin
  {autoload {nvim aniseed.nvim
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

  ;; status line, tree
  :nvim-tree/nvim-web-devicons {}
  :nvim-lualine/lualine.nvim {:mod :lualine}
  :nvim-tree/nvim-tree.lua {:mod :tree}
  :nvim-telescope/telescope.nvim
  {:mod :telescope
   :requires [:nvim-lua/popup.nvim
              :nvim-lua/plenary.nvim
              :nvim-telescope/telescope-ui-select.nvim
              :ahmedkhalf/project.nvim
              :debugloop/telescope-undo.nvim
              :nvim-telescope/telescope-file-browser.nvim]}
  :goolord/alpha-nvim {:mod :alpha
                       ;; don't update as I have code fixed locally;
                       ;; https://github.com/goolord/alpha-nvim/issues/147
                       :commit :21a0f2520ad3a7c32c0822f943368dc063a569fb}
  :Shatur/neovim-session-manager {}
  :RomanoZumbe/harpoon {:mod :harpoon}

  ;; ai
  :zbirenbaum/copilot.lua {:mod :copilot}
  :zbirenbaum/copilot-cmp {}

  ;; repl
  :Olical/conjure {:branch :master :mod :conjure}
  :wlangstroth/vim-racket {:ft [:scheme :racket]}
  :akinsho/toggleterm.nvim {:mod :terminal}
  :samjwill/nvim-unception {} ; no nesting vim sessions.
  :rest-nvim/rest.nvim {:mod :rest}

  ;; sexp
  :guns/vim-sexp {:mod :sexp}
  :tpope/vim-repeat {}
  :kylechui/nvim-surround {:mod :nvim-surround}

  ;; flutter
  :akinsho/flutter-tools.nvim {:requires [:nvim-lua/plenary.nvim]}

  ;; writing
  :jghauser/follow-md-links.nvim {:mod :markdown }
  :preservim/vim-textobj-sentence {:ft [:markdown]}
  :preservim/vim-textobj-quote {:ft [:markdown]
                                :requires [:kana/vim-textobj-user]}
  :uga-rosa/translate.nvim {:mod :translate}

  ;; theme
  :EdenEast/nightfox.nvim {:mod :theme}
  :rose-pine/neovim {}
  :sainnhe/everforest {}
  :sam4llis/nvim-tundra {}
  :f-person/auto-dark-mode.nvim {}

  ;; parsing system
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"
                                    :requires [:p00f/nvim-ts-rainbow]
                                    :mod :treesitter}
  :nvim-treesitter/nvim-treesitter-refactor {}
  :cshuaimin/ssr.nvim {}
  :kevinhwang91/nvim-bqf {}

  ;; lsp
  :neovim/nvim-lspconfig {:mod :lspconfig
                          :requires [:williamboman/mason.nvim
                                     :DNLHC/glance.nvim            ; cmd+b like in idea
                                     :barreiroleo/ltex-extra.nvim  ; ltex code actions
                                     :jose-elias-alvarez/null-ls.nvim
                                     :rmagatti/goto-preview]}

  ;; autocomplete
  :hrsh7th/nvim-cmp {:requires [:hrsh7th/cmp-buffer
                                :hrsh7th/cmp-nvim-lsp
                                :hrsh7th/cmp-path
                                :hrsh7th/cmp-cmdline
                                :f3fora/cmp-spell
                                :PaterJason/cmp-conjure]
                     :mod :cmp}
  :dcampos/nvim-snippy {:requires [:dcampos/cmp-snippy]}

  :EtiamNullam/deferred-clipboard.nvim {}
  :nacro90/numb.nvim {}
  :chrisbra/csv.vim {:mod :csv
                     :ft [:csv :csv_semicolon :csv_whitespace :csv_pipe
                          :tsv :rfc_csv :rfc_semicolon]}
  :eandrju/cellular-automaton.nvim {}
  :chrisbra/Colorizer {:mod :colors
                       :ft [:dart :kotlin :xml :css :scss :js :vue]}
  :akinsho/bufferline.nvim {:mod :tabs}
  ; :AndrewRadev/undoquit.vim {}
  ; :qpkorr/vim-bufkill {}
  :tpope/vim-commentary {}
  :tpope/vim-fugitive {:mod :fugitive}
  :TimUntersberger/neogit {:requires [:nvim-lua/plenary.nvim
                                      :sindrets/diffview.nvim
                                      :lewis6991/gitsigns.nvim]
                           :mod :neogit}
  :vim-scripts/ReplaceWithRegister {}
  :windwp/nvim-autopairs {:mod :nvim-autopairs}
  :mbbill/undotree {:mod :undotree}
  :folke/which-key.nvim {:mod :which}
  :https://gitlab.com/madyanov/svart.nvim {:mod :svart})

; (do (vim.cmd "AniseedEvalFile") (vim.cmd "PackerSync"))
