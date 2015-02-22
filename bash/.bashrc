#export PATH=$PATH:/cygdrive/c/Users/Daniel/Downloads/Utilities/
# $PATH=/cygdrive/c/Users/Daniel/Downloads/Utilities/:$PATH
# export PATH
# export PATH=$( cygpath "$PATH")
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

source ~/.system_aliases
source ~/.cmu_aliases
#source /home/danielti0/busybox-1.21.0/busybox-configure

# Launch zsh as default shell
# zsh
export HARCH=`echo $(uname -m) | sed "s/i./x/g"`
export PATH=$PATH:~/.cabal/bin:~/.xmonad/bin
