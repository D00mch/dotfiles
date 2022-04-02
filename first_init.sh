# submodules
git submodule init
git submodule update

# install oh my zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# prepare dotfiles (after installing zsh) 
rm -rf ~/.zshenv
rm -rf ~/.zshrc
bash init.sh

# installing brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sudo chown -R $(whoami) /usr/local/Cellar

# installing utilities 
brew install fzf
brew install neovim
brew install koekeishiya/formulae/skhd
# https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)
brew install yabai
brew install the_silver_searcher # ag
brew install --cask karabiner-elements
brew install jenv
brew install java
# for :Rg search (like fzf and ag in one place)
brew install ripgrep
# for https://github.com/ludovicchabant/vim-gutentags 
brew install ctags

# start services
brew services start skhd
brew services start yabai

# set up java versions
source ~/.zshrc
source ~/.zshenv
eval "$(jenv init -)"
jenv enable-plugin export
jenv enable-plugin maven
echo "————————————————————————————————————————————"
echo "ADD THIS TO YOUR ENV WITH 'jenv add <path>':"
/usr/libexec/java_home -V
