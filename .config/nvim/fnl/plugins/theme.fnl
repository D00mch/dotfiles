(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local {: kset} (autoload :config.util))

(fn dark? [] (= nvim.o.background "dark"))
(fn transparent? [] (not= 1 vim.g.neovide_transparency))

(set vim.g.neovide_floating_blur_amount_x 8.0)
(set vim.g.neovide_floating_blur_amount_y 8.0)

(fn make-transparent []
  (set vim.g.neovide_transparency 0.93))

(fn make-non-transparent []
  (set vim.g.neovide_transparency 1))

(fn set-theme [dark?]
  ;(make-transparent dark?)
  (set nvim.o.background (if dark? "dark" "light"))
  (vim.api.nvim_command
    (.. "colorscheme " (if dark? "kanagawa-paper" "dawnfox"))))


;;; font

;; update from: https://github.com/ryanoasis/nerd-fonts/releases
(local default-font "Terminess Nerd Font:h19")
; (local default-font "Hack Nerd Font Mono:h15")
; (local default-font "JetBrainsMonoNL Nerd Font Mono:h15")
; (local default-font "Iosevka Nerd Font Mono:h17")
; (local default-font "Iosevka Nerd Font Propo:h17")
; (local default-font "Hack NF:h15")
(set nvim.o.guifont default-font)

(fn font-size! [diff]
  (let [font nvim.o.guifont
        size (-> (nvim.o.guifont:match "h(%d+)$") tonumber (+ diff))]
    (set nvim.o.guifont (font:gsub "%d+$" size))))

[{1 :f-person/auto-dark-mode.nvim
  :lazy false
  :priority 1000
  :dependencies [:nvim-tree/nvim-web-devicons
                 :webhooked/kanso.nvim
                 :sho-87/kanagawa-paper.nvim
                 :EdenEast/nightfox.nvim]
  :init (fn []
          (when vim.g.neovide
            (set nvim.g.neovide_cursor_vfx_mode "railgun")
            (set nvim.g.neovide_input_macos_option_key_is_meta true)
            (kset :n :<Space>tt
                    #(if (transparent?)
                       (make-non-transparent)
                       (make-transparent))
                    "transparency"))

          ; (vim.api.nvim_create_autocmd
          ;   :ColorScheme
          ;   {:buffer   bufnr
          ;    :group    (vim.api.nvim_create_augroup :HighlightColors {:clear true})
          ;    :callback #(if (transparent?)
          ;                 (make-transparent (dark?))
          ;                 (make-non-transparent (dark?)))})

          (let [nightfox (require :nightfox)]
            (nightfox.setup
              {:options
               {:styles {:comments :italic
                         :types :italic
                         :functions :bold}}}))


          (kset :n :+ #(font-size! 1))
          (kset :n :- #(font-size! -1))
          (kset :n :<leader>sd #(set nvim.o.guifont default-font) "Default font size")

          ;;; removing `~` shit in empty files
          (set vim.opt.fillchars { :eob " "}))
  :config (fn []
            (let [auto (require :auto-dark-mode)]
              (auto.setup
                {:update_interval 2000
                 :set_dark_mode #(set-theme true)
                 :set_light_mode #(set-theme false)})
              (auto.init)))}]
