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
  :nvim-tree/nvim-tree.lua {:mod :nvim-tree}
  :stevearc/oil.nvim {:mod :oil}
  :nvim-telescope/telescope.nvim
  {:mod :telescope
   :requires [:nvim-lua/popup.nvim
              :nvim-lua/plenary.nvim
              :nvim-telescope/telescope-ui-select.nvim
              :ahmedkhalf/project.nvim
              :debugloop/telescope-undo.nvim
              :nvim-telescope/telescope-file-browser.nvim]}
  :jackMort/ChatGPT.nvim {:requires :MunifTanjim/nui.nvim}
  :goolord/alpha-nvim {:mod :alpha
                       ;; don't update as I have code fixed locally;
                       ;; https://github.com/goolord/alpha-nvim/issues/147
                       :commit :21a0f2520ad3a7c32c0822f943368dc063a569fb}
  :Shatur/neovim-session-manager {}
  :RomanoZumbe/harpoon {}

  ;; ai
  ; :zbirenbaum/copilot.lua {:mod :copilot}
  ; :zbirenbaum/copilot-cmp {}
  :jcdickinson/codeium.nvim {:mod :codeium}

  ;; repl
  :Olical/conjure {:branch :master :mod :conjure}
  :wlangstroth/vim-racket {:ft [:scheme :racket]}
  :akinsho/toggleterm.nvim {:mod :terminal}
  :rest-nvim/rest.nvim {:mod :rest}

  ;; sexp
  :guns/vim-sexp {:mod :sexp}
  :tpope/vim-repeat {}
  :kylechui/nvim-surround {:mod :nvim-surround}

  ;; flutter
  :akinsho/flutter-tools.nvim {:requires [:nvim-lua/plenary.nvim]}

  ;; writing
  :jghauser/follow-md-links.nvim {}
  :preservim/vim-textobj-sentence {:ft [:markdown]}
  :preservim/vim-textobj-quote {:ft [:markdown]
                                :requires [:kana/vim-textobj-user]}
  :uga-rosa/translate.nvim {:mod :translate}
  :iamcco/markdown-preview.nvim
  {:mod :markdown
   :run (fn []
          ((. vim.fn "mkdp#util#install")))}

  ;; theme
  :f-person/auto-dark-mode.nvim {:mod :theme}
  :stevearc/dressing.nvim {:config "require('dressing').setup ({})"}
  :neanias/everforest-nvim {}
  :askfiy/visual_studio_code {}
  :sainnhe/edge {}
  :briones-gabriel/darcula-solid.nvim {:requires [:rktjmp/lush.nvim]}
  :rebelot/kanagawa.nvim {}
  :projekt0n/github-nvim-theme {}
  :ribru17/bamboo.nvim {}

  ;; parsing, refactoring
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"
                                    :mod :treesitter}
  :vim-scripts/ReplaceWithRegister {}
  :nvim-treesitter/nvim-treesitter-refactor {}
  :HiPhish/nvim-ts-rainbow2 {}
  :cshuaimin/ssr.nvim {} ;; structural search replace
  :kevinhwang91/nvim-bqf {:mod :quickfix}

  ;; lsp
  :neovim/nvim-lspconfig {:mod :lspconfig}
  ;:jose-elias-alvarez/null-ls.nvim {}
  :williamboman/mason.nvim {}     ; install lsp servers      
  :DNLHC/glance.nvim {}           ; cmd+b like in idea
  :barreiroleo/ltex-extra.nvim {} ; ltex code actions
  :rmagatti/goto-preview {}        ; preview definition
  :RRethy/vim-illuminate {}

  ;; autocomplete
  :hrsh7th/cmp-buffer {}
  :hrsh7th/cmp-nvim-lsp {}
  :hrsh7th/cmp-path {}
  :hrsh7th/cmp-cmdline {}
  :f3fora/cmp-spell {}
  :PaterJason/cmp-conjure {}
  :hrsh7th/nvim-cmp {:mod :cmp}
  :dcampos/nvim-snippy {:requires [:dcampos/cmp-snippy]}

  :kevinhwang91/nvim-ufo {:mod :ufo
                          :requires [:kevinhwang91/promise-async]}
  :tpope/vim-sleuth {} ; adjust shiftwidth, expandtab based on file
  :nacro90/numb.nvim {}
  :chrisbra/csv.vim {:mod :csv
                     :ft [:csv :csv_semicolon :csv_whitespace :csv_pipe
                          :tsv :rfc_csv :rfc_semicolon]}
  :eandrju/cellular-automaton.nvim {}
  :chrisbra/Colorizer {:mod :colors
                       :ft [:dart :kotlin :xml :css :scss :js :vue]}
  :akinsho/bufferline.nvim {:mod :tabs}
  ; :AndrewRadev/undoquit.vim {}
  :qpkorr/vim-bufkill {}
  :tpope/vim-commentary {}
  :tpope/vim-fugitive {:mod :git}
  :sindrets/diffview.nvim {}
  :lewis6991/gitsigns.nvim {}
  ; :TimUntersberger/neogit {}
  :windwp/nvim-autopairs {:mod :nvim-autopairs}
  :mbbill/undotree {:mod :undotree}
  :folke/which-key.nvim {:mod :which}
  :https://gitlab.com/madyanov/svart.nvim {:mod :svart})

; (do (vim.cmd "AniseedEvalFile") (vim.cmd "PackerSync"))
