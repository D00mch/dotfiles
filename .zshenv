export VISUAL=vim
export EDITOR="$VISUAL"

export PATH="/usr/local/sbin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/30.0.0:$PATH

export PATH="$HOME/.jenv/bin:$PATH"

export EDITOR='vim'
bindkey -v

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# For fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# For vim-iced
export PATH=$PATH:~/.local/share/nvim/plugged/vim-iced/bin
