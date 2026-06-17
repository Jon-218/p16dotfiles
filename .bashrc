# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ################################### START WORKSPACES ###################################
export WORKSPACES_ROOT=${HOME}
# export WORKSPACES_ROOT="/home/mujin"
# mujin_workspace_make () {
#     CURRENT_WORKING_DIR=$(pwd)
#     MUJIN_WORKSPACE_ID=$1
#     mkdir -p ${WORKSPACES_ROOT}/workspaces/${MUJIN_WORKSPACE_ID}/checkoutroot
#     cd ${WORKSPACES_ROOT}/workspaces/${MUJIN_WORKSPACE_ID}
#     git clone git@git.mujin.co.jp:jhbuild/jhbuildcommon.git
#     git clone git@git.mujin.co.jp:jhbuild/jhbuildappcontroller.git
#     mujin_workspace_set ${MUJIN_WORKSPACE_ID}
#     mujin_jhbuildcommon_updatejhbuildcommon.bash
#     cd ${MUJINJH_APPCONTROLLER_HOME}
#     mujin_jhbuildcommon_initjhbuild.bash
#     jhbuild sysdeps --install
#     mujin_workspace_set ${MUJIN_WORKSPACE_ID}
#     cd ${CURRENT_WORKING_DIR}
# }
# mujin_workspace_set() {
#     MUJIN_WORKSPACE_ID=$1
#     MUJIN_WORKSPACE_ROOT=${WORKSPACES_ROOT}/workspaces/${MUJIN_WORKSPACE_ID}
#     # Clear previous MUJIN env variables
#     unset CMAKE_PREFIX_PATH
#     unset PYTHONPATH
#     unset QML_IMPORT_PATH
#     unset OPENRAVE_PLUGINS
#     unset HDF5_PLUGIN_PATH
#     unset GENICAM_GENTL64_PATH
#     unset QML2_IMPORT_PATH
#     unset OPENRAVE_DATA
#     unset PKG_CONFIG_PATH
#     unset MUJIN_SHUGO_SHARE_DIR
#     unset MUJIN_TESTAPPCONTROLLER_SHARE_DIR
#     unset MUJIN_RESOURCES_SHARE_DIR
#     unset MUJIN_ROBOTS_SHARE_DIR
#     unset QT_PLUGIN_PATH
#     unset MUJIN_APPCONTROLLER_HOME
#     unset MUJIN_APPFRPIECEPICKINGWITHQPS_SHARE_DIR
#     unset MUJIN_TESTREGISTRATION_SHARE_DIR
#     MUJIN_TESTAPPCONTROLLER_SHARE_DIR=${MUJIN_WORKSPACE_ROOT}/checkoutroot/appcontroller/testappcontroller
#     MUJIN_RESOURCES_SHARE_DIR=${MUJIN_WORKSPACE_ROOT}/checkoutroot/resources
#     MUJIN_ROBOTS_SHARE_DIR=${MUJIN_WORKSPACE_ROOT}/checkoutroot/robots
#     QT_PLUGIN_PATH=${MUJIN_WORKSPACE_ROOT}/${MUJIN_WORKSPACE_JHBUILDAPP_NAME}/install/lib/plugins:
#     MUJIN_APPCONTROLLER_HOME=${MUJIN_WORKSPACE_ROOT}/checkoutroot/appcontroller
#     MUJIN_APPFRPIECEPICKINGWITHQPS_SHARE_DIR=${MUJIN_WORKSPACE_ROOT}/checkoutroot/appfrpiecepickingwithqps
#     MUJIN_TESTREGISTRATION_SHARE_DIR=${MUJIN_WORKSPACE_ROOT}/checkoutroot/registration/testregistration
#     for VAR in `printenv | grep ^MUJIN | sed -e 's/=.*$//'`; do
#         unset -f ${VAR}
#     done
#     export MUJIN_WORKSPACE_JHBUILDAPP_NAME="jhbuildappcontroller"
#     echo -e "Configuring Mujin environment: \033[01;32m${MUJIN_WORKSPACE_ID}\033[00m"
#     # Update .jhbuildrc
#     if [ "$(diff -q ${MUJIN_WORKSPACE_ROOT}/${MUJIN_WORKSPACE_JHBUILDAPP_NAME}/.jhbuildrc ${HOME}/.jhbuildrc)" != "" ]; then
#         echo "Updating ~/.jhbuildrc"
#         cp ${MUJIN_WORKSPACE_ROOT}/${MUJIN_WORKSPACE_JHBUILDAPP_NAME}/.jhbuildrc ${HOME}/
#     fi
#     export LD_LIBRARY_PATH="/usr/local/lib"
#     unset PATH
#     export PATH=$ORG_PATH:/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin
#     export PATH=/usr/lib/ccache:$PATH
#     YELLOW='\033[1;33m'
#     GREEN='\033[0;32m'
#     RED='\033[0;31m'
#     NC='\033[0m' # No Color
#     display_text() {
#         # $1 color
#         # $2 text
#         echo -e "$1$2${NC}"
#     }
#     log_info() {
#         display_text $NC "$1"
#     }
#     log_debug() {
#         display_text $GREEN "$1"
#     }
#     log_warn() {
#         display_text $YELLOW "$1"
#     }
#     log_error() {
#         display_text $RED "$1"
#     }
#     if [[ $PATH != *"${MUJIN_WORKSPACE_ROOT}/jhbuildcommon/bin"* ]]; then
#         export PATH="${MUJIN_WORKSPACE_ROOT}/jhbuildcommon/bin:$PATH"
#     fi
#     export MUJINJH_COMMON=${MUJIN_WORKSPACE_ROOT}/jhbuildcommon
#     if [ -f "${MUJINJH_COMMON}/jhbuild/contrib/jhbuild_completion.bash" ]; then
#         source "${MUJINJH_COMMON}/jhbuild/contrib/jhbuild_completion.bash"
#     fi   
# 	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1) \[\033[01;32m\](workspace:${MUJIN_WORKSPACE_ID}) \[\033[00m\]$ '     
# 	export MUJIN_JHBUILD_CHECKOUT_DIR=${MUJIN_WORKSPACE_ROOT}/checkoutroot
#     export MUJINJH_APPCONTROLLER_HOME=${MUJIN_WORKSPACE_ROOT}/${MUJIN_WORKSPACE_JHBUILDAPP_NAME}
#     export D=${MUJIN_WORKSPACE_ROOT}/checkoutroot/detectors/python/mujindetection/
#     # alias unitest="MUJIN_RESOURCES_DIR=/testdata mujin_testcontrollercommon_runpytest.py ${MUJIN_WORKSPACE_ROOT}/checkoutroot/detectors/testdetectors/python/mujintestdetection -m askulbox0*fast"
#     # alias pytst="pytest -p no:cacheprovider -p no:mujintestcommon -v --log-level ERROR -m detector_ci_marker ${MUJIN_WORKSPACE_ROOT}/checkoutroot/testdetectors/python/mujintestdetection/test_detector.py --resource "
#     # alias jb="cd ~/mujin/jhbuildappcontroller/; git checkout master; git pull origin master; mujin_jhbuildcommon_updatejhbuildcommon.bash; mujin_jhbuildcommon_initjhbuild.bash; jhbuild sysdeps --install; jhbuild"
#     export MUJIN_JHBUILD_DOWNLOADS_DIR=${MUJIN_WORKSPACE_ROOT}/downloads
#     source ${MUJINJH_APPCONTROLLER_HOME}/setuptestdev.bash
#     return 0
# }
# mujin_workspace_checkout() {
#     CURRENT_WORKING_DIR=$(pwd)
#     MUJIN_WORKSPACE_ID=$1
#     MUJIN_WORKSPACE_ROOT=${WORKSPACES_ROOT}/workspaces/${MUJIN_WORKSPACE_ID}
#     rm ${HOME}/mujin || true
#     ln -s ${MUJIN_WORKSPACE_ROOT} ${HOME}/mujin
#     cd ${CURRENT_WORKING_DIR}
# }
if [ -f ${WORKSPACES_ROOT} ]; then
    alias mujin_workspace_list='ls --color=never ${WORKSPACES_ROOT}/workspaces'
    CURRENT_WORKSPACES=`mujin_workspace_list`
    complete -W "${CURRENT_WORKSPACES}" mujin_workspace_set
    complete -W "${CURRENT_WORKSPACES}" mujin_workspace_checkout
fi

source $HOME/.workspaceswitcher

# ################################### END WORKSPACES ###################################
# Check out mujin workspace by default (if exists)
# if [ -d "${WORKSPACES_ROOT}/workspaces/mujin" ]; then
#     mujin_workspace_set mujin
#     mujin_workspace_checkout mujin
# fi
export PATH=$PATH:~/.local/bin
# if [ -f ${WORKSPACES_ROOT}/mujin/jhbuildappcontroller/setupdev.bash ]; then
#     source ${WORKSPACES_ROOT}/mujin/jhbuildappcontroller/setupdev.bash
# fi
# if you want to process checkoutroot/dev_module/test_submodule/bin as well, enable below instead (with disabling setupdev.bash)
# source ${WORKSPACES_ROOT}/mujin/jhbuildappcontroller/setuptestdev.bash
# if [ -f ${WORKSPACES_ROOT}/mujin/jhbuildcommon/setup.bash ]; then
#     source ${WORKSPACES_ROOT}/mujin/jhbuildcommon/setup.bash
# fi


mset() {
    export MUJIN_WORKSPACE_ID=$1

    mujin_workspace_set $MUJIN_WORKSPACE_ID
    export MUJIN_CONFIG_DIR=/data/config_local
    # bash -lic "mset $MUJIN_WORKSPACE_ID; zsh"
    # bash -lic "mujin_workspace_set $MUJIN_WORKSPACE_ID; zsh"
    # export PS1=$PS1(ws:$MUJIN_WORKSPACE_ID)
}

mlist() {
    for WS_DIR_NAME in `ls ${WORKSPACES_ROOT}`; do
        if [ -f ${WORKSPACES_ROOT}/${WS_DIR_NAME}/workspaceinfo ]; then
            WS_SHORTDESC="`grep -oP '(?<=MUJIN_WORKSPACE_SHORTDESC=)[^\n]*' ${WORKSPACES_ROOT}/${WS_DIR_NAME}/workspaceinfo`"
            echo $WS_DIR_NAME: ${WS_SHORTDESC}
        fi
    done
}

_mcd() {
    # local word wslist line
    local line

    # word="$1"
    # completions="$(vault --cmplt "${word}")"
    wslist=`find ${HOME}/workspaces -mindepth 1 -maxdepth 1 -type d -name '[!.]*' ! -name 'lost*' -exec basename {} \;`;
    repolist=`find ${HOME}/workspaces/master/checkoutroot -mindepth 1 -maxdepth 1 -type d -name '[!.]*' ! -name 'lost*' -exec basename {} \;`;
    wslist=("${(ps:\n:)wslist}");
    repolist=("${(ps:\n:)repolist}");

    _arguments -C \
        "1:my message:($wslist)" \
        "2:my message:($repolist docker)" \
        # "*::arg:->args"

}

_mopt() {
    # local word wslist line
    local line

    # word="$1"
    # completions="$(vault --cmplt "${word}")"
    wslist=`find ${HOME}/workspaces -mindepth 1 -maxdepth 1 -type d -name '[!.]*' ! -name 'lost*' -exec basename {} \;`;
    # repolist=`find ${HOME}/workspaces/main/checkoutroot -mindepth 1 -maxdepth 1 -type d -name '[!.]*' ! -name 'lost*' -exec basename {} \;`;
    wslist=("${(ps:\n:)wslist}");
    # repolist=("${(ps:\n:)repolist}");
    modelist=('release test')

    _arguments -C \
        "1:my message:($wslist)" \
        "2:my message:($modelist)" \
        # "*::arg:->args"

}

mcd() {
    WORKSPACES=workspaces/$1
    if [[ $2 == "docker" ]]; then
        cd $HOME/$WORKSPACES/jhbuildappcontroller/$2
        mset $1
    else
        cd $HOME/$WORKSPACES/checkoutroot/$2
    fi
}

mopt_set () {
    local buildmode=${2:-"release"}
    local version=-${3:-""}
    if [[ -z $3 ]]; then
        version=''
    fi

    for d in bin devbin lib include share debug; do
        sudo ln -sfT /home/mujin/workspaces/$1/jhbuildappcontroller/docker/install/${buildmode}.mcx${version}/${d} /opt/${d}
    done
}

# ################################### END WORKSPACES ###################################


__fzf_history() {
    builtin history -a
    builtin history -c
    builtin history -r
    builtin typeset \
        READLINE_LINE_NEW="$(
            HISTTIMEFORMAT= builtin history |
                command fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r |
                command sed '
                /^ *[0-9]/ {
                    s/ *\([0-9]*\) .*/!\1/;
                    b end;
                };
                d;
                : end
            '
        )"

    if
        [[ -n $READLINE_LINE_NEW ]]
    then
        builtin bind '"\er": redraw-current-line'
        builtin bind '"\e^": magic-space'
        READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${READLINE_LINE_NEW}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
        READLINE_POINT=$((READLINE_POINT + ${#READLINE_LINE_NEW}))
    else
        builtin bind '"\er":'
        builtin bind '"\e^":'
    fi
}

builtin set -o histexpand
builtin bind -x '"\C-x1": __fzf_history'
builtin bind '"\C-r": "\C-x1\e^\er"'


#mujinsimulator
export PATH=$PATH:/home/mujin/mujin/frkr/mujinsimulator/bin:/home/mujin/.local/share/JetBrains/Toolbox/scripts:/usr/sbin

# mussh
export PATH="${HOME}/mujin/ssh/bin:${PATH}"
[ ! -e /.dockerenv ] && mussh start

. "/home/mujin/.deno/env"
