# help commands start
alias vim=nvim
alias v=vim
alias vi=vim
alias s='source ~/.zshrc; source ~/.zshenv'
alias ~='cd ~'
alias f="find . -name $1"
alias ip="ifconfig | grep 'inet' | grep -Fv 127.0.0.1 | awk '{print $2}'"
alias sleep="sudo systemctl hybrid-sleep"
alias hib="sudo systemctl hibernate"
alias theme="java -jar ~/dotfiles/clj_scripts/theme/target/uberjar/theme-0.1.0-SNAPSHOT-standalone.jar $1"
alias wtheme="theme 'w'"
alias btheme="theme 'b'"
alias c="clear"
alias fz='bash ~/fuz.sh'

# notes
alias todo='vim ~/wiki/todo.md -c ":cd %:p:h"'
alias nt='vim ~/wiki/index.md -c ":cd %:p:h"'

# settings files start
alias dtf='cd ~/dotfiles' 
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias vimplug='vim ~/.local/share/nvim/site'
alias inputrc='vim ~/.inputrc'
alias idearc='vim ~/.ideavimrc'
alias zathurarc='vim ~/.config/zathura/zathurarc'
alias hotkeys='vim ~/.skhdrc'

# vim start
bindkey -v
export KEYTIMEOUT=1
export VI_MODE_SET_CURSOR=true

ZSH_THEME="strug"
plugins=(
    git
    adb
    vi-mode
    python
    lein
    brew
)
source $ZSH/oh-my-zsh.sh

eval "$(jenv init -)"

source ~/.ssh-aliases.sh

# git start
speedUpGit(){
    git config --add oh-my-zsh.hide-status 1
    git config --add oh-my-zsh.hide-dirty 1
}

