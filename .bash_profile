export ANT_HOME=/usr/local/opt/ant
export MAVEN_HOME=/usr/local/opt/maven
export GRADLE_HOME=/usr/local/opt/gradle
export ANDROID_HOME=/Users/dumchev/Library/Android/sdk
export ANDROID_NDK_HOME=/Users/dumchev/Library/Android/sdk/ndk-bundle

# export JAVA_HOME="/usr/libexec/java_home" #wrong path

export PATH=$ANT_HOME/bin:$PATH
export PATH=$MAVEN_HOME/bin:$PATH
export PATH=$GRADLE_HOME/bin:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/24.0.0:$PATH

export PATH=$PATH:/usr/local/opt/android-sdk/ndk-bundle

source /usr/local/git/contrib/completion/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='[\u@mbp \w$(__git_ps1)]\$ '


# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# For telegram-cli
export CFLAGS="-I/usr/local/include -I/usr/local/Cellar/readline/6.3.8/include"
exPort CPPFLAGS="-I/usr/local/opt/openssl/include"
export LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/lib -L/usr/local/Cellar/readline/6.3.8/lib"

export PATH

source ~/git-completion.bash


#----------------------------------
#----------------------------------

# help commands start
alias s='source ~/.bash_profile'
alias ..='cd ../'
alias ...='cd ../../'
alias ~='cd ~'
alias home='cd ~'
alias video="open $1 -a VLC"
alias f="find . -name $1"
alias ip="ifconfig | grep 'inet' | grep -Fv 127.0.0.1 | awk '{print $2}'"

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


# navigation commands start
alias notes="cd ~/Documents/sublime"
alias vimhome="cd /usr/local/share/vim/vim80"
alias delegates="cd ~/AndroidStudioProjects/other/DelegateAdapters/"

# navigation commands end



# android commands start
alias apkinstall="adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X install -r $1"
alias rmapp="adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X uninstall $1"
alias clearappcache='adb shell pm clear $1'
# android commands end


# translation start
alias e='trans en:ru'
alias р='trans ru:en'
# translation end


# settings files start
alias bashrc='vim /Users/dumchev/.bash_profile'
alias vimrc='vim /Users/dumchev/.vimrc'
alias inputrc='vim /Users/dumchev/.inputrc'
alias idearc='vim /Users/dumchev/.ideavimrc'
# settings files end


# autoru start
alias apk='cd ~/AndroidStudioProjects/mobile-autoru-client-android-3/app/build/outputs/apk'
alias auto='cd ~/AndroidStudioProjects/mobile-autoru-client-android-3/'

# remove debug auto
alias rda='adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X uninstall ru.auto.ara.debug'

# remove release auto
alias rpa='adb devices | tail -n +2 | cut -sf 1 | xargs -I X adb -s X uninstall ru.auto.ara'

# clear debug auto
cda(){
   adb shell pm clear 'ru.auto.ara.debug'
}

# clear release auto
cra(){
   adb shell pm clear 'ru.auto.ara'
}

a(){
   auto && git status	
}

ssha(){
	~ && ssh 'dumchev-01-sas.dev.vertis.yandex.net'
}

sh(){
	~ && ssh 'android-build-02-sas.dev.vertis.yandex.net'
}

sshpassport(){
        ~ && ssh 'passport-api-01-sas.test.vertis.yandex.net'
}

mf(){
    ./mainframer-init.sh 'dumchev-01-sas.dev.vertis.yandex.net' '/home/dumchev/mobile-autoru-client-android-3/app' 
}
# autoru end

# telegram in terminal start
alias tlg='cd ~/tg/dumch && ./telegram-cli -k tg-server.pub -c telegram.config'
alias telegram='cd ~/tg/dumch && sudo nc_telegram'
# telegram in terminal end

# gradle start
alias stop='./gradlew --stop'
alias gc=./gradlew clean
# gradle end


#----------------------------------
#----------------------------------
# git start

	# some good aliases and functions start
	alias gst='git status'
	alias gp='git pull'
	alias git-uncommit='git reset --soft HEAD~'

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
	    export PS1="$BLUE\w $LIGHT_RED[\$(git-current-branch)]$DEFAULT \$ "
	}

	set_prompt_line
	# show current branch end

# git end


