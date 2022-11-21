(module plugin.theme
  {require {nvim aniseed.nvim
            str aniseed.string
            fox nightfox
            auto auto-dark-mode
            {: toggle} plugin.which
            {: kset} util}})

(set nvim.g.everforest_background "hard")

(fox.setup
  {:dim_inactive false
   :options {:terminal_colors true}})

(defn set-theme [dark?]
  (when (not vim.g.neovide) (set nvim.o.background (if dark? "dark" "light")))
  (vim.api.nvim_command
    (.. "colorscheme " (if (not vim.g.neovide) "papercolor" dark? "nightfox" "dayfox"))))

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")]
  (set-theme (string.find msg "Dark")))

(toggle "c" "coloscheme" (fn [] (set-theme (not (= vim.o.background "dark")))))

;;; font

(set nvim.o.guifont "Hack Nerd Font Mono:h15")

(defn font-size! [diff]
  (let [font nvim.o.guifont
        size (-> (nvim.o.guifont:match "h(%d+)$") tonumber (+ diff))]
    (set nvim.o.guifont (font:gsub "%d+$" size))))

(kset :n :<Space>+ (fn [] (font-size! 1)))
(kset :n :<Space>- (fn [] (font-size! -1)))

;;; autodark

(auto.setup
  {:update_interval 2000
   :set_dark_mode (fn [] (set-theme true))
   :set_light_mode (fn [] (set-theme false))})
(auto.init)

;;; removing ~ shit
(set vim.opt.fillchars { :eob " "})
