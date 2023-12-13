export CYGWIN="${CYGWIN} nodosfilewarning"

alias l="ls -h"
alias .="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias em="emacs -nw"
alias b="em ~/.bashrc"
alias emb="b"
alias emm="em Makefile"
alias .b="source ~/.bashrc"
alias mcm="make clean && make"
alias gdbtui="gdb -tui"

# Remap RAlt to Ctrl
setxkbmap -option ctrl:ralt_rctrl
source ~/.system_aliases
source ~/.system_funcs
source ~/.pwn_funcs
if [ -f ~/.personal_aliases ]; then
source ~/.personal_aliases
fi
# eval "$(fasd --init auto)"

shorthost () {
  # TODO: Do something to shorten the hostname here
  echo $(hostname)
}

export PS1="\[\e[00;34m\]\$(shorthost) \[\e[00;35m\][\w]\[\e[00;32m\] ~> \[\e[0m\]"

export HARCH=`echo $(uname -m) | sed "s/i./x/g"`
export PATH=$PATH:~/.cabal/bin:~/.xmonad/bin
export TERM=xterm-256color

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
