(module plugin.theme
  {require {nvim aniseed.nvim
             str aniseed.string
             fox nightfox}})

(set nvim.g.sonokai_style "espresso")
(set nvim.g.everforest_background "hard")

(fox.setup 
  {:dim_inactive false
   :options {:terminal_colors true}})

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")
      term? (not (str.blank? (vim.fn.system "echo $TERM"))) ]
  (if (string.find msg "Dark")
    (let [theme* (if term? "papercolor" "nightfox")]
      (set nvim.o.background "dark")
      (vim.api.nvim_command (.. "colorscheme " theme*)))
    (let [theme* (if term? "papercolor" "dayfox")]
      (set nvim.o.background "light")
      (vim.api.nvim_command (.. "colorscheme " theme*)))))
