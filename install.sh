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
INSTALL_CQUERY=false
INSTALL_SSH_ACCESS=false
INSTALL_WALLPAPER=false
INSTALL_ENV=false

if [ ]; then
    echo "This is a comment block"
fi

### PACKAGES ###
sudo apt install git
if [[ "$INSTALL_PACKAGES" == true ]]; then
    echo "--> Installing packages with apt install"
    sudo apt install suckless-tools fish subversion cmake automake npm dfu-util patool exuberant-ctags global vim xclip ncdu sshpass socat zathura dmenu python-xpyb python-pip dos2unix curl keychain stow
    sudo apt install tty-clock screenfetch redshift cowsay
    cd && git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop && /tmp/gotop/scripts/download.sh && sudo mv gotop /usr/local/bin

fi

### DOTFILES ###
if [[ "$INSTALL_DOTFILES" == true ]]; then
    cd
    echo "--> Cloning dotfiles"
    git clone https://github.com/dp12/dotfiles.git
    cd ~/dotfiles
    echo "Stowing dotfiles"
    sudo apt install stow
    stow Xwindows alias bspwm i3 zsh fish git polybar terminator tmux tmuxinator vim
    rm ~/.bashrc ~/.bash_logout
    stow bash
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
    chsh -s `which zsh`
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
    ## ripgrep (grep replacement)
    cd
    echo "Installing ripgrep"
    wget https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
    tar xvzf ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
    cd ripgrep-0.10.0-x86_64-unknown-linux-musl
    sudo cp rg /usr/local/bin
    ## fzy
    cd
    echo "Installing fzy"
    wget https://github.com/jhawthorn/fzy/releases/download/1.0/fzy-1.0.tar.gz
    tar xvzf fzy-1.0.tar.gz && cd fzy-1.0 && make && sudo cp fzy /usr/local/bin
    ## fd (find replacement)
    cd
    echo "Installing fd"
    wget https://github.com/sharkdp/fd/releases/download/v7.1.0/fd_7.1.0_amd64.deb
    sudo dpkg -i fd_7.1.0_amd64.deb
    # exa (ls replacement)
    cd
    echo "Installing exa"
    wget https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
    unzip exa-linux-x86_64-0.8.0.zip
    sudo cp exa-linux-x86_64 /usr/local/bin/exa
    # prettyping (ping replacement)
    cd
    echo "Installing prettyping"
    wget https://github.com/denilsonsa/prettyping/raw/master/prettyping
    chmod +x prettyping && mv prettyping /usr/local/bin/prettyping

    echo "Installing hecate"
    wget https://github.com/evanmiller/hecate/releases/download/v0.0.1/hecate_0.0.1_amd64.deb
    sudo dpkg -i hecate_0.0.1_amd64.deb
fi

### BSPWM ###
if [[ "$INSTALL_BSPWM" == true ]]; then
    cd
    echo "--> Cloning bspwm"
    git clone https://github.com/baskerville/bspwm.git
    echo "Cloning sxhkd"
    git clone https://github.com/baskerville/sxhkd.git
    sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev
    echo "Building bspwm"
    cd bspwm && make && sudo make install
    sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/
    sudo cp ~/dotfiles/bspwm/.config/bspwm/custom_bspwm_badge.png /usr/share/unity-greeter/custom_bspwm_badge.png
    echo "Building sxhkd"
    cd ../sxhkd && make && sudo make install
    echo "Installing i3lock"
    sudo apt install i3lock
    pip install i3-py
    echo "Setting wallpaper"
    local OVERRIDE_BACKGROUND_FILE=/usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override
    local BACKGROUND_FILE=/usr/share/backgrounds/yellowfield.png
    sudo bash -c "echo '[com.canonical.unity-greeter]' > $OVERRIDE_BACKGROUND_FILE"
    sudo bash -c "echo 'draw-user-backgrounds=false' >> $OVERRIDE_BACKGROUND_FILE"
    sudo bash -c "echo \"background='$BACKGROUND_FILE'\" >> $OVERRIDE_BACKGROUND_FILE"
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas
    sudo service lightdm restart
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

if [[ "$INSTALL_ROFI" == true ]]; then
    echo "--> Installing rofi"
    cd
    wget https://launchpad.net/ubuntu/+archive/primary/+files/rofi_0.15.11-1_amd64.deb
    sudo dpkg -i rofi_0.15.11-1_amd64.deb
fi

### EMACS ###
if [[ "$INSTALL_EMACS" == true ]]; then
    echo "--> Installing emacs"
    cd
    sudo apt install make gcc libgtk-3-dev libgnutls-dev libxpm-dev libjpeg-dev libgif-dev libtiff-dev libncurses-dev xorg-dev
    wget https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.gz
    tar xvzf emacs-26.1.tar.gz
    cd emacs-26.1
    echo "Building emacs"

    if [[ "$INSTALL_MU4E" == true ]]; then
        sudo apt install libwebkitgtk-3.0-dev libwebkit2gtk-4.0-dev libgnutls-dev
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
    tar xvzf mu-0.9.18.tar.gz
    cd mu-0.9.18
    echo "Building mu and mu4e"
    autoreconf -i && ./configure && make && sudo make install
    ## mbsync
    cd
    # SHARED_FOLDER=/media/sf_Shared
    # sudo cp $SHARED_FOLDER/isync-1.2.2.tar.gz .
    sudo tar xvzf isync-1.3.0.tar.gz
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
    mbsync -Va
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
    nohup emacs &
fi

### CQUERY ###
if [[ "$INSTALL_CQUERY" == true ]]; then
    echo "--> Installing cquery"
    cd
    git clone --recursive https://github.com/cquery-project/cquery.git
    cd cquery
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=release -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
    cmake --build .
    cmake --build . --target install
fi

### SSH ACCESS ###
if [[ "$INSTALL_SSH_ACCESS" == true ]]; then
    echo "--> Installing openssh-server and allowing port 22 access"
    sudo apt install openssh-server
    sudo ufw allow 22
fi

### WALLPAPER ###
if [[ "$INSTALL_WALLPAPER" == true ]]; then
    echo "--> Installing feh and wallpaper crontab"
    sudo apt install feh
    (crontab -l ; echo '*/1 * * * * DISPLAY=:0.0 feh --bg-max "$(find ~/.wallpaper/|shuf -n1)"') | sort - | uniq - | crontab -
fi

### ENVIRONMENT ###
if [[ "$INSTALL_ENV" == true ]]; then
    echo "export LESS=-MQRi" >> ~/.profile
    echo "export LESSOPEN='|pygmentize -g %s'" >> ~/.profile
    echo "systemctl --user enable ssh-agent" >> ~/.profile
    echo "systemctl --user start ssh-agent" >> ~/.profile
    echo "setxkbmap -option ctrl:ralt_rctrl" >> ~/.profile
fi

### MANUAL STEPS ###
# .config/polybar/config: change the setting until [bar/bar1] for monitor to
# your display, as listed in xrandr --query
#     monitor = VGA-1
#
# .config/bspwm/bspwmrc: change the workspaces listed under bspc monitor XXX to
# your display, as listed in xrandr --query
#     bspc monitor VGA-1 -d i ii iii iv
