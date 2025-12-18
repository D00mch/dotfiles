# install oh my zsh

# Set dotfiles directory (first arg or home directory by default)
DOTFILES_DIR="${1:-$HOME}"
DOTFILES_PATH="$DOTFILES_DIR/dotfiles"

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_PATH" ]; then
    echo "Error: Dotfiles directory not found at $DOTFILES_PATH" >&2
    exit 1
fi

cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# prepare dotfiles (after installing zsh) 
rm -rf ~/.zshenv
rm -rf ~/.zshrc

bash init.sh "$DOTFILES_PATH"

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
brew install --cask nikitabobko/tap/aerospace
brew install --cask karabiner-elements
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

source ~/.zshrc
source ~/.zshenv
