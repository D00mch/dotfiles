export VISUAL=vim
export EDITOR="$VISUAL"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/29.0.3:$PATH
export ANDROID_NDK=~/android-ndk-r21

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

# help commands start
alias s='source ~/.zshrc'
alias ..='cd ../'
alias ...='cd ../../'
alias ~='cd ~'
alias f="find . -name $1"
alias ip="ifconfig | grep 'inet' | grep -Fv 127.0.0.1 | awk '{print $2}'"
alias sleep="sudo systemctl hybrid-sleep"
alias hib="sudo systemctl hibernate"
alias theme="sh ~/changetheme.clj $1"
alias c="clear"

# android commands start
alias apkinstall="adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X install -r $1"
alias ai="apkinstall"
alias rmapp="adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X uninstall $1"
alias clearappcache='adb shell pm clear $1'
# android commands end

#translation start
alias р='trans -b ru:en'
alias e='trans en:ru -brief'
alias eng='trans en:ru'
#translation end

# settings files start
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias inputrc='vim ~/.inputrc'
alias idearc='vim ~/.ideavimrc'
alias zathurarc='vim ~/.config/zathura/zathurarc'
# settings files end

# gradle start
alias stop='./gradlew --stop'
alias gc='./gradlew clean'
# gradle end

ZSH_THEME="robbyrussell"
plugins=(
    git
    adb
    gradle
    vi-mode
)
source $ZSH/oh-my-zsh.sh
