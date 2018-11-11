export ANT_HOME=/usr/local/opt/ant
export MAVEN_HOME=/usr/local/opt/maven
export GRADLE_HOME=/usr/local/opt/gradle
export ANDROID_HOME=/Users/dumchev/Library/Android/sdk
export ANDROID_NDK_HOME=/Users/dumchev/Library/Android/sdk/ndk-bundle

export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_191`

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
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/lib -L/usr/local/Cellar/readline/6.3.8/lib"

export PATH

export CLICOLOR=1

source ~/git-completion.bash

# read non-local shit
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# telegram in terminal start
alias tlg='cd ~/tg/dumch && ./telegram-cli -k tg-server.pub -c telegram.config'
alias telegram='cd ~/tg/dumch && sudo nc_telegram'
# telegram in terminal end

