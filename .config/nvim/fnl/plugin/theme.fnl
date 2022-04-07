(module plugin.theme
  {autoload {nvim aniseed.nvim
             c aniseed.core}})

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")]
  (if (string.find msg "Dark")
    (do 
      (set nvim.o.background "dark")
      (set nvim.g.sonokai_style "espresso")
      (vim.cmd "colorscheme sonokai"))
    (do 
      (set nvim.o.background "light")
      (vim.cmd "colorscheme github"))))

