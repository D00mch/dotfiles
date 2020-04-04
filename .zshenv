export VISUAL=vim
export EDITOR="$VISUAL"

export PATH="/usr/local/sbin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/29.0.3:$PATH
export ANDROID_NDK=~/android-ndk-r20b

export EDITOR='vim'
bindkey -v

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/a18385139/.oh-my-zsh"

# For fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
