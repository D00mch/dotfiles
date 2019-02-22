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


# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# For telegram-cli
export CFLAGS="-I/usr/local/include -I/usr/local/Cellar/readline/6.3.8/include"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/lib -L/usr/local/Cellar/readline/6.3.8/lib"

export PATH

export CLICOLOR=1

source ~/git-completion.bash

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# work aliases start
alias standup='vim ~/Yandex.Disk.localized/notes/wiki/standup.wiki'
# work aliases end

# autoru start
alias apk='cd ~/AndroidStudioProjects/mobile-autoru-client-android-3/app/build/outputs/apk/dev/debug'
alias apkT='cd /Users/dumchev/AndroidStudioProjects/auto-test/app/build/outputs/apk/dev/debug'
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
cpa(){
   adb shell pm clear 'ru.auto.ara'
}

# open debug auto
oda(){
   adb shell am start -n 'ru.auto.ara.debug/ru.auto.ara.SplashActivity'
}

# open release auto
opa(){
   adb shell am start -n 'ru.auto.ara/ru.auto.ara.SplashActivity'
}

a(){
   auto && git status  
}

ssha(){
  ~ && ssh 'dumchev-01-sas.dev.vertis.yandex.net'
}

sshm(){
  ~ && ssh 'android-build-02-sas.dev.vertis.yandex.net'
}

sshpassport(){
        ~ && ssh 'passport-api-01-sas.test.vertis.yandex.net'
}

sshlogs(){
    ssh logs.vertis.yandex.net
}

mf(){
    ./mainframer-init.sh 'dumchev-02-sas.dev.vertis.yandex.net' '/home/dumchev/mobile-autoru-client-android-3/app' 
}
# autoru end
