# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/mujin/.zsh/completions:"* ]]; then export FPATH="/home/mujin/.zsh/completions:$FPATH"; fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z zsh-fzf-history-search zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# ################################### START WORKSPACES ###################################

export WORKSPACES_ROOT=${HOME}/workspaces

mujin_workspace_make() {
    export MUJIN_WORKSPACE_ID=$1
    bash -lic "mujin_workspace_make $MUJIN_WORKSPACE_ID; zsh"
}


mset() {
    if [[ -z $1 ]]; then
        print -u2 "usage: mset <workspace-id>"
        return 1
    fi
    export MUJIN_WORKSPACE_ID=$1

    # 退出当前 conda 环境(未激活时静默忽略)
    conda deactivate 2>/dev/null

    # mujin_workspace_set 以及它 source 的 setuprepoenv.bash 都是 bash 脚本,
    # zsh 无法直接 source。所以仍让 bash 执行,跑完后把产生的环境变量 dump 回
    # 当前 zsh —— 不再 `; zsh` 嵌套出新 shell,变量直接在本 shell 生效。
    #
    # 用非交互 `bash -lc`(不是 -i):交互式 bash 会开 job control 抢终端,在
    # 进程替换 <(...) 里不是前台进程组会被挂起 → 卡住。这里显式 source
    # .workspaceswitcher 来定义函数(不依赖 .bashrc),并把 stdin 接到 /dev/null。
    #
    #   mujin_workspace_set ... 1>&2  : 把函数的彩色提示输出留在终端,不污染 dump
    #   env -0                        : 以 NUL 分隔输出环境,read -d '' 逐条读回
    local key val
    while IFS='=' read -r -d '' key val; do
        case $key in
            # 不要覆盖 shell 自身 / 会话相关变量(PS1 是 bash 风格,导回 zsh 是乱码)
            PWD|OLDPWD|SHLVL|_|SHELL|PS1|PROMPT|RPROMPT) continue ;;
            BASH*|ZSH*|FUNCNAME) continue ;;
        esac
        export "$key=$val"
    done < <(bash -lc 'source "$HOME/.workspaceswitcher"; mujin_workspace_set "$1" 1>&2; env -0' bash "$1" </dev/null)
    export VIRTUAL_ENV="ws_$MUJIN_WORKSPACE_ID"
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
    repolist=`find ${HOME}/workspaces/frkr/checkoutroot -mindepth 1 -maxdepth 1 -type d -name '[!.]*' ! -name 'lost*' -exec basename {} \;`;
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
    # repolist=`find ${HOME}/workspaces/frkr/checkoutroot -mindepth 1 -maxdepth 1 -type d -name '[!.]*' ! -name 'lost*' -exec basename {} \;`;
    wslist=("${(ps:\n:)wslist}");
    # repolist=("${(ps:\n:)repolist}");
    modelist=('dev test')

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
        if [[ $1 == sub* ]]; then
            echo "work space in sub folder"
            cd $HOME/$WORKSPACES/../checkoutroot/$2
        else
            cd $HOME/$WORKSPACES/checkoutroot/$2
        fi
        # cd $HOME/$WORKSPACES/checkoutroot/$2
    fi
}

mopt_set () {
    local buildmode=${2:-"test"}
    local version=-${3:-""}
    if [[ -z $3 ]]; then
        version=''
    fi

    for d in bin devbin lib include share debug; do
        sudo ln -sfT /home/mujin/workspaces/$1/jhbuildappcontroller/docker/install/${buildmode}.mcx${version}/${d} /opt/${d}
    done
}

dedate() {
    timeStamp=$1
    ms=${timeStamp:10:13}
    timeStamp=${timeStamp:0:10}

    utc=`date -d @$timeStamp -u +"%Y-%m-%d %H:%M:%S %Z"`
    if [[ $2 == "jp" ]]; then
        jpt=`TZ='Asia/Tokyo' date -d $utc +"%Y-%m-%d %H:%M:%S %Z"`
        echo ${jpt:0:19},$ms${jpt:19:23}
    elif [[ $2 == "us" ]]; then
        ust=`TZ='America/New_York' date -d $utc +"%Y-%m-%d %H:%M:%S %Z"`
        echo ${ust:0:19},$ms${ust:19:23}
    else
        hkt=`date -d $utc +"%Y-%m-%d %H:%M:%S %Z"`
        echo ${hkt:0:19},$ms${hkt:19:23}
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# compctl -f -K _mcd mcd
compdef _mcd mcd
compdef _mcd mset
compdef _mopt mopt_set

if [[ $MUJIN_WORKSPACE_ID ]]; then
    # export PS1="$PS1(ws:$MUJIN_WORKSPACE_ID) "
    #alias pycharm="pycharm /home/jiang/workspaces/$MUJIN_WORKSPACE_ID/checkoutroot/detectors "
    typeset -g POWERLEVEL9K_ANACONDA_VISUAL_IDENTIFIER_EXPANSION='⭐'
    export CONDA_PREFIX=$MUJIN_WORKSPACE_ID
fi

# ################################### END WORKSPACES ###################################

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias kb="kill %%"
alias bat="batcat"
alias pipins="python3 -m pip install --break-system-packages"
alias pipuins="python3 -m pip uninstall --break-system-packages"
alias oprv="OPENRAVE_DATA=$(pwd) openrave.py --openravescheme=mujin -i"

# mussh
export PATH="${HOME}/mujin/ssh/bin:${PATH}"
[ ! -e /.dockerenv ] && mussh start

source $HOME/.musshrc

export PATH=$PATH:$HOME/.local/bin:$HOME/.local/share/JetBrains/Toolbox/scripts:/sbin:/usr/sbin:/usr/local/sbin:$HOME/mujin/ssh/bin:$HOME/.cargo/bin:$HOME/mujin/devbin:/usr/local/go/bin
# export PYTHONPATH=$PYTHONPATH:/home/mujin/.local/lib/python3.13/dist-pakages

source ~/miniconda3/bin/activate

