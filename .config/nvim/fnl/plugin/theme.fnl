(module plugin.theme
  {require {nvim aniseed.nvim
            str aniseed.string
            fox nightfox
            auto auto-dark-mode
            tundra nvim-tundra
            {: toggle} plugin.which
            {: kset} util}})

(defn dark? [] (= nvim.o.background "dark"))

;;; neovide

(defn transparent? [] (= 0 nvim.g.neovide_transparency))

(defn make-transparent [dark?]
  (set vim.g.neovide_transparency 0.0)
  (set vim.g.transparency 0.9)
  (if dark?
    (vim.cmd "let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))")
    (vim.cmd "let g:neovide_background_color = '#FFFFFF'.printf('%x', float2nr(255 * g:transparency))")))

(defn make-non-transparent [dark?]
  (set vim.g.neovide_transparency 1.0)
  (set vim.g.transparency 1.0)
  (if dark?
     (vim.cmd "let g:neovide_background_color = '#0f1117'")
     (vim.cmd "let g:neovide_background_color = '#FFF'")))

(when vim.g.neovide
  (set nvim.g.neovide_cursor_vfx_mode "railgun")
  (toggle "t"
          "transparency"
          #(if (transparent?)
             (make-non-transparent (dark?))
             (make-transparent (dark?)))))

(vim.api.nvim_create_autocmd
      :ColorScheme
      {:buffer   bufnr
       :group    (vim.api.nvim_create_augroup :HighlightColors {:clear true})
       :callback #(if (transparent?)
                    (make-transparent (dark?))
                    (make-non-transparent (dark?)))})

;;; theme

(set nvim.g.everforest_background "hard")

(fox.setup
  {:dim_inactive false
   :options {:terminal_colors true}})

(tundra.setup
  {:plugins {:lsp        true
             :treesitter true
             :telescope  true
             :nvimtree   true
             :cmp        true
             :gitsigns   true
             :context    false
             :dbui       false}})

(defn set-theme [dark?]
  (when (not vim.g.neovide) (set nvim.o.background (if dark? "dark" "light")))
  (vim.api.nvim_command
    (.. "colorscheme " (if (not vim.g.neovide) "papercolor" dark? "nightfox" "dayfox"))))

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")]
  (set-theme (string.find msg "Dark")))

(toggle "c" "coloscheme" #(set-theme (not (dark?))))

;;; font

(set nvim.o.guifont "Hack Nerd Font Mono:h15")

(defn font-size! [diff]
  (let [font nvim.o.guifont
        size (-> (nvim.o.guifont:match "h(%d+)$") tonumber (+ diff))]
    (set nvim.o.guifont (font:gsub "%d+$" size))))

(kset :n :<Space>= #(font-size! 1))
(kset :n :<Space>- #(font-size! -1))

;;; autodark

(auto.setup
  {:update_interval 2000
   :set_dark_mode #(set-theme true)
   :set_light_mode #(set-theme false)})
(auto.init)

;;; removing ~ shit
(set vim.opt.fillchars { :eob " "})
