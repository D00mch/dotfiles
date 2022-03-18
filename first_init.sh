# submodules
git submodule init
git submodule update

# install oh my zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# prepare dotfiles (after installing zsh) 
bash init.sh

# installing brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# installing utilities 
brew install fzf
brew install neovim
brew install koekeishiya/formulae/skhd
# https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)
brew install yabai
brew install the_silver_searcher # ag
brew install --cask karabiner-elements

# start services
brew services start skhd
brew services start yabai

