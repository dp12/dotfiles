# dotfiles

Configs for zsh/bash/fish, git, tmux, i3, awesome, and vim, plus some handy aliases.

## Aliases
system_aliases is compatible with zsh, bash, and fish shells. Features handy aliases for commands like ls, cd, emacs, apt-get, and git. Why `cd ..` when you can `..` instead?

## i3 Window Manager
![i3wm-of-jeannie](/../master/screenshots/i3wm-of-jeannie.png?raw=true)
i3m-of-jeannie is my personal i3wm theme with conky and rofi, representing my best efforts to "de-uglify" i3. It features CPU, RAM, disk usage, battery, weather, and date/time, using the unicode symbol glyph hack first demonstrated by [ivyl](https://github.com/ivyl/i3-config). All common commands are designed to be issued with two keys (mod4 + a letter). Some features are still in progress. Requires rofi, conky, and tamsynmod font to be installed, as well as Droid Sans Mono for Powerline.

For displaying weather on Debian/Ubuntu, run `sudo apt-get install weather-utils` and add the line `id = <your_zipcode>` to /etc/weatherrc.

Keybinding            | Description
----------------------|------------------------------------------------------------
<kbd>mod4+e</kbd>     | Launch emacs.
<kbd>mod4+p</kbd>     | Launch rofi (dmenu-like application launcher).
<kbd>mod4+d</kbd>     | Launch dmenu.
<kbd>mod4+c</kbd>     | Close application.
<kbd>mod4+Shift-r</kbd> | Reload i3 configuration.
<kbd>mod4+Enter</kbd>   | Launch urxvt terminal.
<kbd>mod4+Shift+Enter</kbd> | Launch terminator terminal.
<kbd>mod4+Delete</kbd> | Launch system shutdown/reboot/logoff/reload menu (compatible with Ubuntu).
<kbd>mod4+Left</kbd>  | Move to workspace on the left.
<kbd>mod4+Right</kbd> | Move to workspace on the right.

##Tmux
Features extremely quick pane and window spawn/kill/switching, using ctrl-arrows and shift-arrows, respectively. The prefix key is set to C-t, in order to reduce friction with emacs. Requires tmux 1.9 in order to support tmux-resurrect and tmux-yank plugins (but you can disable them, if desired).

Keybinding         | Description
-------------------|------------------------------------------------------------
<kbd>C-t t</kbd>   | Change to last-window by pressing Ctrl-t, letting go, and pressing t again.
<kbd>C-tt...</kbd> | By holding down Ctrl and pressing t repeatedly, you can cycle through panes with this chained command.
<kbd>S-up</kbd>    | Create new-window.
<kbd>S-down</kbd>  | Kill window.
<kbd>S-left</kbd>  | Previous window.
<kbd>S-right</kbd> | Next window.
<kbd>C-up</kbd>    | Select pane above.
<kbd>C-down</kbd>  | Select pane below.
<kbd>C-left</kbd>  | Select pane to the left.
<kbd>C-right</kbd> | Select pane to the right.
<kbd>C-t SPC </kbd> | Auto-rearrange the pane configuration.
<kbd>C-t \|</kbd>  | Split the window into smaller panes vertically.
<kbd>C-t =</kbd>   | Split the window into smaller panes horizontally.
<kbd>C-t ,</kbd>   | Rename current window.
<kbd>C-t r</kbd>   | Reload the .tmux.conf file.

## Zsh
My zsh configuration uses [antigen](https://github.com/zsh-users/antigen) for package management and [agnoster](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes#agnoster) as the prompt, which requires a powerline-patched font. Completion functions are provided through zprezto modules, and zaw is included for helm-like history search with `C-r`.

## Miscellaneous Thoughts
* After trying xmonad and awesome, I found that while I enjoyed the power of tiling window managers, I had no earthly idea what to do when they broke, which they did often and horribly. Then I found i3, a tiling window manager configurable in plain English, which instantly prints out the location of any errors when you load it. It's probably one of the best tiling window managers in terms of readability.
