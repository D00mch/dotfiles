(module plugin.theme
  {autoload {nvim aniseed.nvim
             c aniseed.core}})


(set nvim.g.sonokai_style "espresso")
(set nvim.g.everforest_background "hard")

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")]
  (if (string.find msg "Dark")
    (do 
      (set nvim.o.background "dark")
      (vim.api.nvim_command "colorscheme sonokai"))
    (do 
      (set nvim.o.background "light")
      (vim.api.nvim_command "colorscheme github"))))
