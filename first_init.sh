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
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc

# set up java versions
source ~/.zshrc
source ~/.zshenv
