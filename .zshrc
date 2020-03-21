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
alias adb_root_remount_shell="adb root; adb remount; adb shell"
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

source ~/.sber.sh
