(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: toggle} (require :config.which))
(local {: kset} (autoload :config.util))

(fn dark? [] (= nvim.o.background "dark"))
(fn transparent? [] (= 0 nvim.g.neovide_transparency))

(fn alpha []
  (string.format "%x" (math.floor (or (* 255 vim.g.transparency) 0.8))))	

(fn make-transparent [dark?]
  (set vim.g.neovide_transparency 0.0)
  (set vim.g.transparency 0.92)
  (if dark?
    (set vim.g.neovide_background_color (.. "#0f1117" (alpha)))
    (set vim.g.neovide_background_color (.. "#f2f2f2" (alpha)))))

(fn make-non-transparent [dark?]
  (set vim.g.neovide_transparency 1.0)
  (set vim.g.transparency 1.0)
  (if dark?
     (vim.cmd "let g:neovide_background_color = '#0f1117'")
     (vim.cmd "let g:neovide_background_color = '#FFF'")))

(fn set-theme [dark?]
  (make-transparent dark?)
  (set nvim.o.background (if dark? "dark" "light"))
  (vim.api.nvim_command "colorscheme everforest")
  (vim.api.nvim_command
    (.. "colorscheme " (if dark? "kanagawa-dragon" "dawnfox"))))


;;; font

;; update from: https://github.com/ryanoasis/nerd-fonts/releases
(local default-font "Hack Nerd Font Mono:h15")
; (def default-font "JetBrainsMonoNL Nerd Font Mono:h15")
; (def default-font "Iosevka Nerd Font Mono:h17")
; (def default-font "Iosevka Nerd Font Propo:h17")
; (def default-font "Hack NF:h15")
(set nvim.o.guifont default-font)

(fn font-size! [diff]
  (let [font nvim.o.guifont
        size (-> (nvim.o.guifont:match "h(%d+)$") tonumber (+ diff))]
    (set nvim.o.guifont (font:gsub "%d+$" size))))

[{1 :f-person/auto-dark-mode.nvim
  :lazy false
  :priority 1000
  :dependencies [:nvim-tree/nvim-web-devicons
                 :neanias/everforest-nvim
                 :sainnhe/edge
                 :rebelot/kanagawa.nvim
                 :EdenEast/nightfox.nvim]
  :init (fn []
          (when vim.g.neovide
            (set nvim.g.neovide_cursor_vfx_mode "railgun")
            (set nvim.g.neovide_input_macos_alt_is_meta true)
            (toggle "t"
                    "transparency"
                    #(if (transparent?)
                       (make-non-transparent (dark?))
                       (make-transparent (dark?)))))

          ; (vim.api.nvim_create_autocmd
          ;   :ColorScheme
          ;   {:buffer   bufnr
          ;    :group    (vim.api.nvim_create_augroup :HighlightColors {:clear true})
          ;    :callback #(if (transparent?)
          ;                 (make-transparent (dark?))
          ;                 (make-non-transparent (dark?)))})

          (let [everforest (require :everforest)
                nightfox (require :nightfox)]
            (everforest.setup {:background :hard})
            (nightfox.setup
              {:options
               {:styles {:comments :italic
                         :types :italic
                         :functions :bold}}}))


          (kset :n :<D-=> #(font-size! 1))
          (kset :n :<D--> #(font-size! -1))
          (kset :n :<D-0> #(set nvim.o.guifont default-font))

          ;;; removing `~` shit in empty files
          (set vim.opt.fillchars { :eob " "}))
  :config (fn []
            (let [auto (require :auto-dark-mode)]
              (auto.setup
                {:update_interval 2000
                 :set_dark_mode #(set-theme true)
                 :set_light_mode #(set-theme false)})
              (auto.init)))}]