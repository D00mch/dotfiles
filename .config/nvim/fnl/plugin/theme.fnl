(module plugin.theme
  {autoload {nvim aniseed.nvim
             fox nightfox}})

(set nvim.g.sonokai_style "espresso")
(set nvim.g.everforest_background "hard")

(fox.setup 
  {:dim_inactive false
   :options {:terminal_colors true}})

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")]
  (if (string.find msg "Dark")
    (do 
      (set nvim.o.background "dark")
      (vim.api.nvim_command "colorscheme nightfox"))
    (do 
      (set nvim.o.background "light")
      (vim.api.nvim_command "colorscheme dayfox"))))
