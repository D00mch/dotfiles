# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# help commands start
alias s='source ~/.zshrc; source ~/.zshenv'
alias ~='cd ~'
alias ip="ifconfig | grep 'inet' | grep -Fv 127.0.0.1 | awk '{print $2}'"
alias sleep="sudo systemctl hybrid-sleep"
alias theme="java -jar ~/dotfiles/clj_scripts/theme/target/default+uberjar/theme-0.1.0-SNAPSHOT-standalone.jar $1"
alias wtheme="theme 'w'"
alias btheme="theme 'b'"
alias c="clear"

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
alias rehotkeys='launchctl kickstart -k "gui/${UID}/homebrew.mxcl.skhd"'
alias yabairc='vim ~/.yabairc'
alias reyabai='yabai --restart-service'

# vim start
bindkey -v
export KEYTIMEOUT=1
export VI_MODE_SET_CURSOR=true

plugins=(
    git
    adb
    vi-mode
    python
    lein
    brew
    gradle
)
source $ZSH/oh-my-zsh.sh

source ~/.ssh-aliases.sh

# git start
speedUpGit(){
    git config --add oh-my-zsh.hide-status 1
    git config --add oh-my-zsh.hide-dirty 1
}
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
