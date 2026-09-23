#!/usr/bin/env bash

# Use this script's directory unless a repository path is supplied.
DOTFILES_PATH="$(cd "${1:-$(dirname "${BASH_SOURCE[0]}")}" && pwd -P)" || exit 1

# install oh my zsh without opening an interactive shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# prepare dotfiles (after installing zsh) 
rm -rf ~/.zshenv
rm -rf ~/.zshrc

bash "$DOTFILES_PATH/init.sh" "$DOTFILES_PATH"

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
bash "$DOTFILES_PATH/scripts/set-default-text-app.sh"
brew install --cask font-terminess-ttf-nerd-font
brew install yqrashawn/goku/goku
brew install --cask nikitabobko/tap/aerospace
brew install --cask karabiner-elements
brew install --cask alfred
brew install --cask betterdisplay
brew install jq
brew install java
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
brew install leiningen
brew install clojure
brew install borkdude/brew/clj-kondo
brew install ripgrep
brew install wezterm
brew install go
brew install --cask google-chrome
brew install --cask sioyek
brew install pgformatter
brew install --cask vlc
brew install rust
brew install pandoc
cargo install --locked evcxr_repl # repl
cargo install --locked tree-sitter-cli
brew tap y3owk1n/tap
brew install --cask y3owk1n/tap/neru

echo "Setup finished. Open a new terminal to load your shell configuration."
