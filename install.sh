#!/usr/bin/env bash
set -eEuo pipefail
INSTALL_PACKAGES=false
INSTALL_DOTFILES=false
INSTALL_ZSH=false
INSTALL_TMUX=false
INSTALL_FONTS=false
INSTALL_UTILS=false
INSTALL_BSPWM=false
INSTALL_POLYBAR=false
INSTALL_EMACS=false
INSTALL_GCCEMACS=false
INSTALL_DOOM=false
INSTALL_MU4E=false
INSTALL_SPACEMACS=false
INSTALL_ROFI=false
INSTALL_KAKOUNE=false
INSTALL_CQUERY=false
INSTALL_SSH_ACCESS=false
INSTALL_WALLPAPER=false
INSTALL_ANIMATED_WALLPAPER=false
INSTALL_ENV=false

if [ ]; then
    echo "This is a comment block"
fi

latest_release() {
    curl -sL "https://api.github.com/repos/$1/releases/latest" | jq -r ".tag_name"
}

### PACKAGES ###
if [[ "$INSTALL_PACKAGES" == true ]]; then
    echo "--> Installing packages with apt install"
    sudo apt install -y git curl suckless-tools fish subversion cmake automake npm dfu-util patool exuberant-ctags global vim xclip ncdu nnn sshpass socat zathura dos2unix keychain stow mosh curl jq
    #sudo apt install -y python-xpyb python-pip
    sudo apt install -y tty-clock screenfetch redshift cowsay
    # install rust, cargo, and dependencies
    sudo apt remove -y --purge cargo
    sudo wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip -O /usr/local/bin/greenclip
    sudo chmod +x /usr/local/bin/greenclip
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
    cargo install tealdeer
    cargo install hyperfine

    echo "--> Installing lazydocker"
    cd
    VER="$(latest_release jesseduffield/lazydocker)"
    wget https://github.com/jesseduffield/lazydocker/releases/download/${VER}/lazydocker_${VER/#v}_Linux_x86_64.tar.gz
    tar xvzf lazydocker_${VER/#v}_Linux_x86_64.tar.gz lazydocker
    sudo mv lazydocker /usr/local/bin
fi

### DOTFILES ###
if [[ "$INSTALL_DOTFILES" == true ]]; then
    if ! [ -d "$HOME/dotfiles" ]; then
      cd
      echo "--> Cloning dotfiles"
      git clone https://github.com/dp12/dotfiles.git
    fi
    cd ~/dotfiles
    echo "Stowing dotfiles"
    sudo apt install -y stow
    stow Xwindows alias bspwm i3 zsh fish git helix polybar profile terminator tmux tmuxinator vim
    rm ~/.bashrc ~/.bash_logout
    stow bash
fi

### Z-SHELL ###
if [[ "$INSTALL_ZSH" == true ]]; then
    echo "--> Installing zsh"
    cd
    sudo apt install -y zsh
    echo "Cloning zaw"
    git clone https://github.com/zsh-users/zaw.git ~/.zaw

    echo "Installing antibody"
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

    #Seems to fail with a sha256sum error
    #curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
    echo "Installing nerdfont"
    cd /usr/share/fonts
    sudo wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Medium/complete/Roboto%20Mono%20Medium%20Nerd%20Font%20Complete.ttf
    fc-cache -fv /usr/share/fonts
    echo "Changing default shell to zsh"
    chsh -s `which zsh`
    sudo chsh -s `which zsh`
fi

### TMUX ###
if [[ "$INSTALL_TMUX" == true ]]; then
    echo "--> Installing tmux"
    sudo apt install -y tmux tmuxinator terminator
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
    echo "Enabling bitmap fonts"
    sudo ln -s /etc/fonts/conf.avail/70-force-bitmaps.conf /etc/fonts/conf.d/
    sudo unlink /etc/fonts/conf.d/70-no-bitmaps.conf
    cd
    echo "Cloning powerline fonts"
    git clone https://github.com/powerline/fonts.git
    ./fonts/install.sh
    rm -rf fonts

    echo "Installing Fixedsys Excelsior"
    wget https://github.com/kika/fixedsys/releases/download/v3.02.9/FSEX302.ttf
    sudo mv FSEX302.ttf /usr/share/fonts

    echo "Installing JetBrains Mono Nerd Font"
    wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Medium/complete/JetBrains%20Mono%20Nerd%20Font%20Complete%20Medium.ttf
    sudo mv "JetBrains Mono Nerd Font Complete Medium.ttf" /usr/share/fonts

    echo "Installing GohuFont"
    wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Gohu/uni-14/complete/GohuFont%20Nerd%20Font%20Complete%20Mono.ttf
    sudo mv 'GohuFont Nerd Font Complete Mono.ttf' /usr/share/fonts
    fc-cache -fv
fi

### UTILITIES ###
if [[ "$INSTALL_UTILS" == true ]]; then
    echo "--> Installing utils"
    cd
    ## ripgrep (grep replacement)
    cd
    echo "Installing ripgrep"
    VER="$(latest_release burntsushi/ripgrep)"
    wget "https://github.com/BurntSushi/ripgrep/releases/download/${VER}/ripgrep-${VER}-x86_64-unknown-linux-musl.tar.gz"
    tar xvzf "ripgrep-${VER}-x86_64-unknown-linux-musl.tar.gz"
    cd "ripgrep-${VER}-x86_64-unknown-linux-musl"
    sudo cp rg /usr/local/bin
    ## fzf
    cd
    echo "Installing fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    ## fzy
    cd
    echo "Installing fzy"
    VER="$(latest_release jhawthorn/fzy)"
    wget "https://github.com/jhawthorn/fzy/releases/download/${VER}/fzy-${VER}.tar.gz"
    tar xvzf "fzy-${VER}.tar.gz" && cd "fzy-${VER}" && make && sudo cp fzy /usr/local/bin
    ## fd (find replacement)
    cd
    echo "Installing fd"
    VER="$(latest_release sharkdp/fd)"
    wget "https://github.com/sharkdp/fd/releases/download/${VER}/fd_${VER/#v}_amd64.deb"
    sudo dpkg -i "fd_${VER/#v}_amd64.deb"
    # exa (ls replacement)
    cd
    echo "Installing exa"
    VER="$(latest_release ogham/exa)"
    wget "https://github.com/ogham/exa/releases/download/${VER}/exa-linux-x86_64-${VER}.zip"
    unzip "exa-linux-x86_64-${VER}.zip" -d exa_download
    sudo cp exa_download/bin/exa /usr/local/bin/exa
    # prettyping (ping replacement)
    cd
    echo "Installing prettyping"
    wget https://github.com/denilsonsa/prettyping/raw/master/prettyping
    chmod +x prettyping && sudo mv prettyping /usr/local/bin/prettyping

    #echo "Installing hecate"
    #wget https://github.com/evanmiller/hecate/releases/download/v0.0.1/hecate_0.0.1_amd64.deb
    #sudo dpkg -i hecate_0.0.1_amd64.deb
fi

### BSPWM ###
if [[ "$INSTALL_BSPWM" == true ]]; then
    cd
    sudo apt install -y bspwm
    #echo "--> Cloning bspwm"
    #git clone https://github.com/baskerville/bspwm.git
    #echo "Cloning sxhkd"
    #git clone https://github.com/baskerville/sxhkd.git
    #sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev make
    #echo "Building bspwm"
    #cd bspwm && make && sudo make install
    #sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/
    #sudo cp ~/dotfiles/bspwm/.config/bspwm/custom_bspwm_badge.png /usr/share/unity-greeter/custom_bspwm_badge.png
    #echo "Building sxhkd"
    #cd ../sxhkd && make && sudo make install

    echo "Installing bsp-layout"
    git clone https://github.com/phenax/bsp-layout.git
    cd bsp-layout
    git checkout 0.0.9
    sudo make install

    echo "Installing i3lock"
    sudo apt install -y i3lock
    python3 -m pip install i3-py
    echo "Installing compton"
    sudo apt install -y compton
    # Set up compton.conf
    ln -s ~/.config/bspwm/compton.conf ~/.config/compton.conf

    echo "Setting wallpaper"
    # OVERRIDE_BACKGROUND_FILE=/usr/share/glib-2.0/schemas/10_unity_greeter_background.gschema.override
    # BACKGROUND_FILE=/usr/share/backgrounds/yellowfield.png
    # sudo bash -c "echo '[com.canonical.unity-greeter]' > $OVERRIDE_BACKGROUND_FILE"
    # sudo bash -c "echo 'draw-user-backgrounds=false' >> $OVERRIDE_BACKGROUND_FILE"
    # sudo bash -c "echo \"background='$BACKGROUND_FILE'\" >> $OVERRIDE_BACKGROUND_FILE"
    # sudo glib-compile-schemas /usr/share/glib-2.0/schemas
    sudo service gdm start

    echo "--> Installing bsp-layout"
    cd
    git clone https://github.com/phenax/bsp-layout.git
    cd bsp-layout
    sudo make install
fi

### POLYBAR ###
if [[ "$INSTALL_POLYBAR" == true ]]; then
    echo "--> Installing polybar"
    sudo apt install polybar
    # sudo apt install -y cmake g++ libcairo2-dev xcb-proto libxcb-util-dev libxcb-xkb-dev libxcb-image0-dev libxcb-composite0-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-ewmh-dev
    # sudo apt install -y python3-xcbgen
    # cd
    # echo "Cloning polybar"
    # VER="$(latest_release polybar/polybar)"
    # wget https://github.com/jaagr/polybar/releases/download/${VER}/polybar-${VER}.tar.gz
    # tar xvzf polybar-${VER}.tar.gz
    # #git clone --branch 3.0.5 --recursive https://github.com/jaagr/polybar
    # cd polybar-${VER}
    # ./build.sh
    # #mkdir polybar/build
    # #cd polybar/build
    # #cmake ..
    # cd build
    # sudo make install
fi

if [[ "$INSTALL_ROFI" == true ]]; then
    echo "--> Installing rofi"
    # cd
    # wget https://launchpad.net/ubuntu/+archive/primary/+files/rofi_1.5.1-1_amd64.deb
    # sudo dpkg -i rofi_1.5.1-1_amd64.deb
    sudo apt install -y rofi
fi

### EMACS ###
if [[ "$INSTALL_EMACS" == true ]]; then
    echo "--> Installing emacs"
    cd
    sudo apt install -y make gcc autoconf libgtk-3-dev libxpm-dev libjpeg-dev libgif-dev libtiff-dev libncurses-dev xorg-dev texinfo libxml2-dev
    #sudo apt install -y libgnutls-dev
    sudo apt install -y libgnutls28-dev
    git clone -b master git://git.sv.gnu.org/emacs.git
    cd emacs
    #wget https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.gz
    #tar xvzf emacs-26.1.tar.gz
    #cd emacs-26.1
    echo "Building emacs"

    if [[ "$INSTALL_GCCEMACS" == true ]]; then
        sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa
        sudo apt update -y
        sudo apt install -y gcc-10 libgccjit0 libgccjit-10-dev
        sudo apt install -y libjansson4 libjansson-dev
        #git checkout feature/native-comp
        export CC=/usr/bin/gcc-10 CXX=/usr/bin/gcc-10
        ./autogen.sh
        ./configure --with-native-compilation --with-json CFLAGS="-O3 -mtune=native -march=native -fomit-frame-pointer"
        make && sudo make install
    fi
    if [[ "$INSTALL_MU4E" == true ]]; then
        sudo apt install -y libwebkitgtk-3.0-dev libwebkit2gtk-4.0-dev libgnutls-dev
        ./autogen.sh
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
    sudo apt install -y msmtp libxapian-dev libgmime-2.6-dev libssl-dev libtool-bin
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
    sudo apt install -y python-jedi libclang-3.8-dev
    echo "Cloning spacemacs"
    git clone https://github.com/dp12/spacemacs.git ~/.spacemacs.d

    # Launch emacs to install spacemacs
    echo "Installing spacemacs"
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    nohup emacs &
fi

### DOOM EMACS ###
if [[ "$INSTALL_DOOM" == true ]]; then
    cd
    echo "--> Installing doom emacs"
    echo "Cloning doom"
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    echo "Run doom install"
    ~/.emacs.d/bin/doom install
    echo "Clone doom configuration"
    rm -rf ~/.doom.d
    git clone git@github.com:dp12/doom.git ~/.doom.d
    echo "Sync doom"
    ~/.emacs.d/bin/doom sync
fi

### KAKOUNE ###
if [[ "$INSTALL_KAKOUNE" == true ]]; then
    echo "--> Installing kakoune"
    cd
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test
    sudo apt update && sudo apt install -y gcc-11 g++-11
    sudo apt install -y libncursesw5-dev pkg-config
    git clone https://github.com/mawww/kakoune.git && cd kakoune/src
    CC="gcc-11" CXX="g++-11" make
    PREFIX=/usr/local/bin sudo make install
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
    sudo apt install -y openssh-server
    sudo ufw allow 22
fi

### WALLPAPER ###
if [[ "$INSTALL_WALLPAPER" == true ]]; then
    echo "--> Installing feh and wallpaper crontab"
    sudo apt install -y feh
    (crontab -l ; echo '*/1 * * * * DISPLAY=:0.0 feh --bg-max "$(find ~/.wallpaper/|shuf -n1)"') | sort - | uniq - | crontab -
fi

if [[ "$INSTALL_ANIMATED_WALLPAPER" == true ]]; then
    echo "--> Installing asetroot and animated wallpapers"
    cd
    sudo apt install -y libimlib2-dev
    git clone https://github.com/Wilnath/asetroot.git
    cd asetroot
    make
    mv ~/train.gif ./
    mkdir train_wallpaper
    convert train.gif -coalesce -resize 1920x1080 train_wallpaper/%05d.gif
    ~/asetroot/asetroot ~/asetroot/train_wallpaper/ &
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
