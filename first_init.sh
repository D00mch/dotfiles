# install oh my zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# prepare dotfiles (after installing zsh) 
rm -rf ~/.zshenv
rm -rf ~/.zshrc
bash init.sh $1

# installing brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)
# brew autocompletion https://docs.brew.sh/Shell-Completion
echo 'if type brew &>/dev/null' >> ~/.zprofile 
echo 'then' >> ~/.zprofile 
echo '  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"' >> ~/.zprofile 
echo '  autoload -Uz compinit' >> ~/.zprofile 
echo '  compinit' >> ~/.zprofile 
echo 'fi' >> ~/.zprofile 

# installing utilities 
brew install neovim
brew install --cask neovide
brew install yqrashawn/goku/goku
# https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)
brew install yabai
brew install --cask karabiner-elements
brew install jq
brew install java
brew install leiningen
brew install clojure
brew install borkdude/brew/clj-kondo
brew install ripgrep
brew install wezterm

# for lualine and nerdtree icons
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# start services
brew services start yabai

# set up java versions
source ~/.zshrc
source ~/.zshenv
