#!/usr/bin/env bash

# Same as gspr, defined in case the former has not been sourced
git_save_pull_and_restore() {
    if ! git diff-index --quiet HEAD --; then
        cowsay "In $(basename $(git rev-parse --show-toplevel)):

git stash save; git pull --rebase; git stash pop"
        git stash save; git pull --rebase; git stash pop
    else
        cowsay "In $(basename $(git rev-parse --show-toplevel)):

git pull --rebase"
        git pull --rebase
    fi
}

echo "Updating .doom.d"
cd ~/.doom.d && git_save_pull_and_restore

echo "Updating .spacemacs.d"
cd ~/.spacemacs.d && git_save_pull_and_restore

echo "Updating .emacs.d"
cd ~/.emacs.d && git_save_pull_and_restore

echo "Updating dotfiles"
cd ~/dotfiles && git_save_pull_and_restore

