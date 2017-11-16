# dotfiles

Configs for zsh/bash/fish, git, tmux, bspwm, i3, awesome, and vim, plus some handy aliases.

## Installation
An install.sh script is provided to allow the user to choose what to install and automate the installation. Ubuntu 16.04 is assumed.

## Aliases
system_aliases is compatible with zsh, bash, and fish shells. Features handy aliases for commands like ls, cd, emacs, apt-get, and git. Why `cd ..` when you can `..` instead?

## bspwm
![bspwm](/../master/screenshots/bspwm.png?raw=true)
I'm currently using [bspwm](https://github.com/baskerville/bspwm) as my tiling window manager of choice, using [polybar](https://github.com/jaagr/polybar) for displaying CPU, RAM, disk space, battery life, and time. To install the custom bspwm badge (modified mirror image of awesome), copy custom_bspwm_badge.png to /usr/share/unity-greeter. Keybindings configured in sxhkdrc are mostly the same as the i3 equivalents below.

## Tmux
Features a novel new keybinding scheme that is extremely quick and doesn't require use of the prefix key. Fast and intuitive pane and window spawn/kill/switching operations are done with ctrl-arrows and shift-arrows, respectively. Even more functions are provided with ctrl-alt combinations, such as window splitting. The prefix key is set to C-t, in order to reduce friction with emacs. Requires tmux 1.9 and the [tmux plugin manager](https://github.com/tmux-plugins/tpm) in order to support tmux-resurrect and tmux-yank plugins (but you can disable them, if desired).

Keybinding            | Description
----------------------|------------------------------------------------------------
<kbd>S-up</kbd>       | Create new-window.
<kbd>S-down</kbd>     | Kill window.
<kbd>S-left</kbd>     | Previous window.
<kbd>S-right</kbd>    | Next window.
<kbd>C-up</kbd>       | Select pane above.
<kbd>C-down</kbd>     | Select pane below.
<kbd>C-left</kbd>     | Select pane to the left.
<kbd>C-right</kbd>    | Select pane to the right.
<kbd>C-M-up</kbd>     | Restart a pane that is hung.
<kbd>C-M-down</kbd>   | Kill a pane
<kbd>C-M-left</kbd>   | Swap pane left
<kbd>C-M-right</kbd>  | Swap pane right
<kbd>C-M-\\</kbd>     | Split the window into smaller panes vertically.
<kbd>C-M-]</kbd>      | Split the window into smaller panes horizontally.
<kbd>C-t e</kbd>      | Synchronize panes (toggle sending commands to all panes in the current window).
<kbd>C-t SPC </kbd>   | Auto-rearrange the pane configuration.
<kbd>C-t ,</kbd>      | Rename current window.
<kbd>C-t r</kbd>      | Reload the .tmux.conf file.


## i3 (no longer maintained, see bspwm above)
![glowfish](/../master/screenshots/glowfish.png?raw=true)
Glowfish is a custom i3wm theme with conky and rofi, representing my best efforts to "de-uglify" i3. It is semi-inspired by the [daylerees](https://github.com/daylerees/colour-schemes) glowfish theme and copies the [awesome copycats](https://github.com/copycat-killer/awesome-copycats) multicolor theme bar colors. Glowfish features CPU, RAM, disk usage, battery, weather, and date/time, using glyphs supplied by Siji font. All common commands are designed to be issued with two keys (mod4 + a letter). Some features are still in progress. Requires rofi, conky, and tamsyn and [Siji](https://github.com/gstk/siji) fonts to be installed, as well as Droid Sans Mono for Powerline.

For displaying weather on Debian/Ubuntu, run `sudo apt-get install weather-utils` and add the line `id = <your_zipcode>` to /etc/weatherrc.

Keybinding            | Description
----------------------|------------------------------------------------------------
<kbd>mod4+e</kbd>     | Launch emacs.
<kbd>mod4+p</kbd>     | Launch rofi (dmenu-like application launcher).
<kbd>mod4+d</kbd>     | Launch dmenu.
<kbd>mod4+c</kbd>     | Close application.
<kbd>mod4+Shift-r</kbd> | Reload i3 configuration.
<kbd>mod4+Enter</kbd> | Launch terminator terminal.
<kbd>mod4+Shift+Enter</kbd>   | Launch urxvt terminal.
<kbd>mod4+Delete</kbd> | Launch system shutdown/reboot/logoff/reload menu (compatible with Ubuntu).
<kbd>mod4+Shift+x</kbd> | Launch a prettier, but slightly buggy system shutdown/reboot/logoff/reload menu using dzen2 (compatible with Ubuntu).
<kbd>mod4+Shift+p</kbd> | Lock the desktop with the [py3lock script](https://gist.github.com/Airblader/3a96a407e16dae155744) from Airblader.
<kbd>mod4+Left</kbd>  | Move to workspace on the left.
<kbd>mod4+Right</kbd> | Move to workspace on the right.

## Zsh
My zsh configuration uses [antigen](https://github.com/zsh-users/antigen) for package management and [agnoster](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes#agnoster) as the prompt, which requires a powerline-patched font. Install the former to a `~/.antigen` folder. Completion functions are provided through zprezto modules, and zaw is included for helm-like history search with `C-r`. Clone the [zaw](https://github.com/zsh-users/zaw) repo to `~/.zaw`.

## Miscellaneous Thoughts
* After trying xmonad and awesome, I found that while I enjoyed the power of tiling window managers, I had no earthly idea what to do when they broke, which they did often and horribly. The amount of time spent fixing them was just not commensurate to the amount of functionality I was gaining. Then I found i3, a tiling window manager configurable in plain English, which instantly prints out the location of any errors when you load it. It's probably one of the best tiling window managers out there in terms of readability. Most recently, I switched to bspwm, which is more terse, but simple to configure as well.
