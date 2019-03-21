#
# ~/.bash_aliases
#

# help commands start
alias s='source ~/.bash_profile'
alias ..='cd ../'
alias ...='cd ../../'
alias ~='cd ~'
alias home='cd ~'
alias video="open $1 -a Elmedia\ Player"
alias f="find . -name $1"
alias ip="ifconfig | grep 'inet' | grep -Fv 127.0.0.1 | awk '{print $2}'"
alias sleep="sudo systemctl hybrid-sleep"
alias hibernate="sudo systemctl hibernate"
alias csi="chicken-csi"

md () { mkdir -p "$@" && cd "$@"; }

calc () {
    bc -l «< "$@"
}

eye() {
  defaults write com.apple.finder AppleShowAllFiles YES
        killall Finder
}

noeye(){
  defaults write com.apple.finder AppleShowAllFiles NO
        killall Finder
}

c(){
 	clear
}

lock(){
	/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}
# help commands end

#sicp start
alias sicp='cd ~/Yandex.Disk/notes/wiki/sicp'
alias sicpread='zathura ~/Desktop/sicp.pdf'
alias sicpreadrus='zathura ~/Desktop/sicp_rus.pdf'
#sicp end

# navigation commands start
alias notes="cd ~/Yandex.Disk/notes/vim"
alias book="cd ~/Yandex.Disk/notes/wiki"

alias vimhome="cd /usr/local/share/vim/vim80"
alias delegates="cd ~/AndroidStudioProjects/other/DelegateAdapters/"
# navigation commands end

# notes
fz(){
        bash ~/Yandex.Disk/notes/fuz.sh $@
}
#

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
alias bashrc='vim ~/.bash_aliases'
alias vimrc='vim ~/.vimrc'
alias inputrc='vim ~/.inputrc'
alias idearc='vim ~/.ideavimrc'
alias zathurarc='vim ~/.config/zathura/zathurarc'
# settings files end

# gradle start
alias stop='./gradlew --stop'
alias gc='./gradlew clean'
# gradle end

# work with panes start
slime1(){
    screen -S A
}
slime2(){
    screen -ls | grep Attached | cut -f2
    screen -X eval "msgwait 0"
}

# work with panes end

#----------------------------------
#----------------------------------
# git start

	# some good aliases and functions start
	alias gst='git status'
	alias gp='git pull'
	alias git-uncommit='git reset --soft HEAD~'
        alias dcheck='./gradlew detektCheck'

        # remove all branches
        alias grb='git branch | grep -v "master" | xargs git branch -D'

	amend(){
		git commit -a --amend --no-edit
	}
	# some good aliases and functions end

	# show current branch start
	function git-current-branch {
    	git branch --no-color 2> /dev/null | grep \* | colrm 1 2
	}

	function set_prompt_line {
	    local        BLUE="\[\033[0;34m\]"

	    # OPTIONAL - if you want to use any of these other colors:
	    local         RED="\[\033[0;31m\]"
	    local   LIGHT_RED="\[\033[1;31m\]"
	    local       GREEN="\[\033[0;32m\]"
	    local LIGHT_GREEN="\[\033[1;32m\]"
	    local       WHITE="\[\033[1;37m\]"
	    local  LIGHT_GRAY="\[\033[0;37m\]"
	    # END OPTIONAL
	    local     DEFAULT="\[\033[0m\]"
	    export PS1="$WHITE\w $LIGHT_RED[\$(git-current-branch)]$DEFAULT \$ "
	}

	set_prompt_line
	# show current branch end

# git end

# Local Variables:
# mode: sh
# End:
