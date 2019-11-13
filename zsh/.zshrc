command_exists () {
  type "$1" &> /dev/null;
}

is_linux () {
    [[ $('uname') == 'Linux' ]];
}

is_osx () {
    [[ $('uname') == 'Darwin' ]]
}

DISABLE_AUTO_TITLE="true"
DISABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="false"

# Powerlevel9K modeline configuration
POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs vi_mode)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_VI_INSERT_MODE_STRING=""
POWERLEVEL9K_VI_COMMAND_MODE_STRING="N"
# POWERLEVEL9K_VCS_HIDE_TAGS=true
# POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-tagname)
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_GIT_ICON=$'\uF113 ' # make cat appear always
POWERLEVEL9K_MODE='nerdfont-complete'

# source "$HOME/.antigen/antigen.zsh"
source <(antibody init)

# antibody use oh-my-zsh

antibody bundle <<EOBUNDLES
robbyrussell/oh-my-zsh path:plugins/command-not-found
robbyrussell/oh-my-zsh path:plugins/colored-man-pages
robbyrussell/oh-my-zsh path:plugins/git
robbyrussell/oh-my-zsh path:plugins/git-extras
robbyrussell/oh-my-zsh path:plugins/pip
robbyrussell/oh-my-zsh path:plugins/z
zsh-users/zsh-completions
zsh-users/zsh-history-substring-search
zdharma/fast-syntax-highlighting
# zsh-users/zsh-syntax-highlighting
unixorn/autoupdate-antigen.zshplugin
unixorn/git-extra-commands
voronkovich/gitignore.plugin.zsh
tarruda/zsh-autosuggestions
ascii-soup/zsh-url-highlighter
hlissner/zsh-autopair
b4b4r07/zsh-vimode-visual
Vifon/deer

# MikeDacre/cdbk                # set bookmark aliases quickly
# djui/alias-tips               # reminds you if you didn't use an alias
# fasd
# last-working-dir
# mfaerevaag/wd
# supercrabtree/k
EOBUNDLES

# Theme
# antigen theme agnoster
antibody bundle bhilburn/powerlevel9k
## Other nice themes
# antigen bundle sindresorhus/pure
# antigen theme bullet-train
# antigen theme muse
# antigen theme steeef
# antigen theme fishy
export DEFAULT_USER=$USER    # suppress ssh user info for agnoster

antibody bundle sorin-ionescu/prezto path:modules/completion

# antigen bundle zsh-users/zaw
# From: http://blog.patshead.com/2013/04/more-powerful-zsh-history-search-using-zaw.html

# Clone zaw from https://github.com/zsh-users/zaw into .zaw
# Antigen bundling appears to be broken
source ~/.zaw/zaw.zsh
bindkey -M filterselect '^R' down-line-or-history
bindkey -M filterselect '^S' up-line-or-history
bindkey -M filterselect '^E' accept-search

zstyle ':filter-select:highlight' matched fg=green
zstyle ':filter-select' max-lines 3
zstyle ':filter-select' case-insensitive yes # enable case-insensitive
zstyle ':filter-select' extended-search yes # see below
bindkey '^R' zaw-history

if is_osx; then
  # zsh-history-substring-search
  # bind UP and DOWN arrow keys
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
elif is_linux; then
  # bind UP and DOWN arrow keys
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  # bind P and N for EMACS mode
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down

  bindkey -M vicmd '^A' beginning-of-line
  bindkey -M viins '^A' beginning-of-line
  bindkey -M vicmd '^E' end-of-line
  bindkey -M viins '^E' end-of-line

  # bind k and j for VI mode
  bindkey -M vicmd '^R' zaw-history
  bindkey -M viins '^R' zaw-history
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi

# antigen bundle tarruda/zsh-autosuggestions
# zle-line-init() {
#     zle autosuggest-start
# }
# zle -N zle-line-init

# antigen apply
autoload -U deer
zle -N deer
bindkey '\ek' deer
bindkey '\eD' deer

export PATH=$PATH:/opt/emacs/bin
export VISUAL=vim
export PATH=$PATH:~/.gem/ruby/2.1.0/bin

# User ctrl-z like alt-tab
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# From: http://askubuntu.com/questions/1577/moving-from-bash-to-zsh
autoload -U compinit

for func in $^fpath.zwc(N-.r:); autoload -U -w $func

setopt completeinword
setopt prompt_subst

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

autoload select-word-style
select-word-style shell

HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=5000
setopt incappendhistory
setopt sharehistory
setopt extendedhistory

# superglobs
setopt extendedglob
unsetopt caseglob
unsetopt nomatch 2>/dev/null

setopt interactivecomments # pound sign in interactive prompt

setopt auto_cd
autoload -U promptinit && promptinit

# Vi mode
bindkey -v
bindkey -M viins '^f' autosuggest-accept
bindkey -M vicmd '^f' autosuggest-accept
bindkey -M viins 'kj' vi-cmd-mode
bindkey -M viins '\e.' insert-last-word
bindkey -M viins '^k' kill-line
# bindkey '^R' history-incremental-pattern-search-backward

# Allow deleting backwards
# http://www.zsh.org/mla/workers/2008/msg01653.html
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# 10ms for key sequences
KEYTIMEOUT=1

if command_exists 'rvm'; then
  source /usr/local/rvm/scripts/rvm
fi

# # Prediction
# autoload predict-on
# autoload predict-off

# zle -N predict-on
# zle -N predict-off
# bindkey '^X1' predict-on
# bindkey '^X2' predict-off
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=128'
bindkey '^[f' autosuggest-accept

# Enable fzf fuzzy matcher
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

cdf() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# Remap RAlt to Ctrl
# See options at /usr/share/X11/xkb/rules/evdev.lst
## For Mac keyboard
# setxkbmap -option altwin:swap_lalt_lwin
# setxkbmap -option ctrl:swap_rwin_rctl
# For Windows keyboard
setxkbmap -option ctrl:ralt_rctrl
source ~/.system_aliases
source ~/.system_funcs
if [ -f ~/.personal_aliases ]; then
    source ~/.personal_aliases
fi

# Setup for fasd (broken on my system)
# eval "$(fasd --init posix-alias zsh-hook)"

# fasd_cache="$HOME/.fasd-init-bash"
# if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
# eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)" >| "$fasd_cache"
# fi
# source "$fasd_cache"
# unset fasd_cache
# jump to recently used items
# alias a='fasd -a' # any
# alias s='fasd -si' # show / search / select
# alias d='fasd -d' # directory
# alias f='fasd -f' # file
# alias z='fasd_cd -d' # cd, same functionality as j in autojump
# alias zz='fasd_cd -d -i' # interactive directory jump

# TMUX Launch
alias tmux='tmux -2'
function tmux_launch {
    if [[ -z $TMUX ]]; then
        # Attempt to discover a detached session and attach it, else create a new session
        # CURRENT_USER=$(whoami)
        TMUX_CON_SESSION=__dev__
        if tmux has-session -t $TMUX_CON_SESSION 2>/dev/null; then
            tmux -2 attach-session -t $TMUX_CON_SESSION
        else
            tmux -2 new-session -s $TMUX_CON_SESSION
        fi
    else
        # If inside tmux session then print MOTD
        MOTD=/etc/motd.tcl
        if [ -f $MOTD ]; then
            $MOTD
        fi
    fi
}

alias tml='tmux_launch'
alias msd='mux start dev'

# Newest directory/file, from http://zzapper.co.uk/zshtips.html
alias -g ND='*(/om[1])'
alias -g NF='*(.om[1])'

# Uncomment to launch Tmux session on every new terminal
# mux start dev
