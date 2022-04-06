(module plugin.theme
  {autoload {nvim aniseed.nvim
             c aniseed.core}})

(nvim.ex.set :wrap)
(nvim.ex.set "wildmode=full")

(set nvim.o.undodir "$HOME/.vim/undo")
(set nvim.o.tabstop 2)

(nvim.ex.set "clipboard-=unnamedplus")

(set vim.g.colores_name "sonokai")

(let [(ok? msg) (pcall vim.fn.system "defaults read -g AppleInterfaceStyle")]
  (if (string.find msg "Dark")
    (do 
      (set nvim.o.background "dark")
      (set nvim.g.sonokai_style "espresso")
      (vim.cmd "colorscheme sonokai"))
    (do 
      (set nvim.o.background "light")
      (vim.cmd "colorscheme github"))))

