(module plugin.theme
  {require {nvim aniseed.nvim
            str aniseed.string
            auto auto-dark-mode
            everforest everforest
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
  (set nvim.g.neovide_input_macos_alt_is_meta true)
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

(everforest.setup {:background :hard})

; (set nvim.g.everforest_background "hard")

(defn set-theme [dark?]
  (set nvim.o.background (if dark? "dark" "light"))
  (vim.api.nvim_command
    (.. "colorscheme " (if dark? "visual_studio_code_dark" "ayu-light"))))

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
