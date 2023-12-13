export _JAVA_AWT_WM_NONREPARENTING=1
source "$HOME/.cargo/env"

# Load up PATH
export LESS=-MQRi
export EDITOR=emacsclient
export PATH=$HOME/.cask/bin:$PATH

# Start the greenclip daemon
killall greenclip >/dev/null 2>&1 ; nohup greenclip daemon > /dev/null 2>&1 &
