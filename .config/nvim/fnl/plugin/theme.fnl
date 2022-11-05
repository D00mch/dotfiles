(module plugin.theme
  {require {nvim aniseed.nvim
             str aniseed.string
             fox nightfox
             {: kset} util}})

(set nvim.g.sonokai_style "espresso")
(set nvim.g.everforest_background "hard")

(fox.setup
  {:dim_inactive false
   :options {:terminal_colors true}})

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")
      neovide?  vim.g.neovide]
  (if (string.find msg "Dark")
    (let [theme* (if neovide? "terafox" "papercolor")]
      (set nvim.o.background "dark")
      (vim.api.nvim_command (.. "colorscheme " theme*)))
    (let [theme* (if neovide? "dayfox" "papercolor")]
      (set nvim.o.background "light")
      (vim.api.nvim_command (.. "colorscheme " theme*)))))

;;; font

(set nvim.o.guifont "Hack Nerd Font Mono:h15")

(defn font-size! [diff]
  (let [font nvim.o.guifont
        size (-> (nvim.o.guifont:match "h(%d+)$") tonumber (+ diff))]
    (set nvim.o.guifont (font:gsub "%d+$" size))))

(kset :n :<Space>+ (fn [] (font-size! 1)))
(kset :n :<Space>- (fn [] (font-size! -1)))
