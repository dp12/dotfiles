#!/usr/bin/env bash
INSTALL_PACKAGES=true
INSTALL_DOTFILES=true
INSTALL_ZSH=true
INSTALL_TMUX=true
INSTALL_FONTS=true
INSTALL_UTILS=true
INSTALL_BSPWM=true
INSTALL_POLYBAR=true
INSTALL_EMACS=true
INSTALL_MU4E=true
INSTALL_SPACEMACS=true

if [ ]; then
    echo "This is a comment block"
fi

### PACKAGES ###
sudo apt install git
if [[ "$INSTALL_PACKAGES" == true ]]; then
    echo "--> Installing packages with apt install"
    sudo apt install suckless-tools fish subversion cmake automake npm dfu-util patool exuberant-ctags global vim xclip ncdu sshpass socat zathura feh dmenu python-xpyb python-pip dos2unix curl
fi

### DOTFILES ###
if [[ "$INSTALL_DOTFILES" == true ]]; then
    cd
    echo "--> Cloning dotfiles"
    git clone https://github.com/dp12/dotfiles.git
    cd ~/dotfiles
    echo "Stowing dotfiles"
    sudo apt install stow
    stow Xwindows alias bspwm fish git polybar terminator tmux tmuxinator vim zsh
fi

### Z-SHELL ###
if [[ "$INSTALL_ZSH" == true ]]; then
    echo "--> Installing zsh"
    cd
    sudo apt install zsh
    echo "Cloning zaw"
    git clone https://github.com/zsh-users/zaw.git ~/.zaw
    echo "Installing antigen"
    mkdir .antigen
    cd .antigen
    curl -L git.io/antigen > antigen.zsh
    echo "Changing default shell to zsh"
    sudo chsh -s `which zsh`
fi

### TMUX ###
if [[ "$INSTALL_TMUX" == true ]]; then
    echo "--> Installing tmux"
    sudo apt install tmux tmuxinator terminator
    echo "Cloning tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # TODO: copy terminator config
fi


### FONTS ###
if [[ "$INSTALL_FONTS" == true ]]; then
    cd
    echo "--> Installing bitmap fonts"
    git clone https://github.com/Tecate/bitmap-fonts.git
    sudo cp -avr bitmap-fonts/bitmap/ /usr/share/fonts
    fc-cache -fv
    echo "Enabling bitmap fonts"
    sudo ln -s /etc/fonts/conf.avail/70-force-bitmaps.conf /etc/fonts/conf.d/
    sudo unlink /etc/fonts/conf.d/70-no-bitmaps.conf
    cd
    echo "Cloning powerline fonts"
    git clone https://github.com/powerline/fonts.git
    ./fonts/install.sh
    rm -rf fonts
fi

### UTILITIES ###
if [[ "$INSTALL_UTILS" == true ]]; then
    echo "--> Installing utils"
    cd
    ## ripgrep
    echo "Installing ripgrep"
    wget https://github.com/BurntSushi/ripgrep/releases/download/0.5.2/ripgrep-0.5.2-x86_64-unknown-linux-musl.tar.gz
    tar -xvzf ripgrep-0.5.2-x86_64-unknown-linux-musl.tar.gz
    cd ripgrep-0.5.2-x86_64-unknown-linux-musl
    sudo cp rg /usr/local/bin
    ## fzy
    echo "Installing fzy"
    wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
    sudo dpkg -i fzy_0.9-1_amd64.deb
fi

### BSPWM ###
if [[ "$INSTALL_BSPWM" == true ]]; then
    cd
    echo "--> Cloning bspwm"
    git clone https://github.com/baskerville/bspwm.git
    echo "Cloning sxhkd"
    git clone https://github.com/baskerville/sxhkd.git
    sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev
    echo "Building bspwm"
    cd bspwm && make && sudo make install
    sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/
    echo "Building sxhkd"
    cd ../sxhkd && make && sudo make install
fi

### POLYBAR ###
if [[ "$INSTALL_POLYBAR" == true ]]; then
    echo "--> Installing polybar"
    sudo apt install libcairo2-dev xcb-proto libxcb-util-dev libxcb-xkb-dev libxcb-image0-dev python-xcbgen
    cd
    echo "Cloning polybar"
    git clone --branch 3.0.5 --recursive https://github.com/jaagr/polybar
    mkdir polybar/build
    cd polybar/build
    cmake ..
    sudo make install
fi

### EMACS ###
if [[ "$INSTALL_EMACS" == true ]]; then
    echo "--> Installing emacs"
    cd
    sudo apt install libxpm-dev libjpeg-dev libgif-dev libtiff-dev libncurses-dev
    if [[ "$INSTALL_MU4E" == true ]]; then
        sudo apt install libgtk-3-dev libwebkitgtk-3.0-dev 
    fi
    wget http://ftp.gnu.org/gnu/emacs/emacs-25.2.tar.gz
    tar -xvzf emacs-25.2.tar.gz
    cd emacs-25.2
    echo "Building emacs"

    if [[ "$INSTALL_MU4E" == true ]]; then
        sudo apt install libgtk-3-dev libwebkitgtk-3.0-dev
        ./configure --with-modules --with-x-toolkit=gtk3 --with-xwidgets
    else
        ./configure --with-modules
    fi
    make && sudo make install
fi

### MU4E ###
if [[ "$INSTALL_MU4E" == true ]]; then
    echo "--> Installing mu4e"
    echo "Installing msmtp"
    sudo apt install msmtp libxapian-dev libgmime-2.6-dev libssl-dev libtool-bin
    cd
    ## mu
    wget https://github.com/djcb/mu/releases/download/0.9.18/mu-0.9.18.tar.gz
    tar -xvzf mu-0.9.18.tar.gz
    cd mu-0.9.18
    echo "Building mu and mu4e"
    autoreconf -i && ./configure && make && sudo make install
    ## mbsync
    cd
    SHARED_FOLDER=/media/sf_Shared
    sudo cp $SHARED_FOLDER/isync-1.2.2.tar.gz .
    sudo tar -xvzf isync-1.2.2.tar.gz
    cd isync-1.2.2
    echo "Building mbsync"
    ./configure && make && sudo make install

    echo "Making Maildir/Outlook"
    mkdir -p ~/Maildir/Outlook
    cd
    user=$(whoami)
    echo "Copying mail configuration"
    sudo cp $SHARED_FOLDER/.authinfo .
    sudo cp $SHARED_FOLDER/.authinfo.gpg .
    sudo cp $SHARED_FOLDER/.mailrc .
    sudo cp $SHARED_FOLDER/.mbsyncpass.gpg .
    sudo cp $SHARED_FOLDER/.mbsyncrc .
    sudo cp $SHARED_FOLDER/.msmtprc .
    sudo chgrp $user .m* && sudo chown $user .m*
    sudo chgrp $user .authinfo* && sudo chown $user .authinfo*
    mbsync -a
    mu index --maildir=~/Maildir
fi

### SPACEMACS ###
if [[ "$INSTALL_SPACEMACS" == true ]]; then
    echo "--> Installing spacemacs"
    sudo apt install python-jedi libclang-3.8-dev
    echo "Cloning spacemacs"
    git clone https://github.com/dp12/spacemacs.git ~/.spacemacs.d

    # Launch emacs to install spacemacs
    echo "Installing spacemacs"
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    emacs
fi
