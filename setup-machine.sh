#!/bin/bash

# go to the dir of this script
cd "$(dirname "$0")"

# remove unneeded things
sudo dnf remove -y \
    evolution \
    rhythmbox

# basic update
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf upgrade -y

# CLI tools
sudo dnf install -y \
    ansible \
    curl \
    dnf-plugins-core \
    gcc \
    git \
    jq \
    neovim \
    powerline \
    python2-neovim \
    python3 python3-devel python3-neovim \
    redhat-rpm-config \
    ruby ruby-devel \
    ShellCheck \
    tig \
    unrar \
    util-linux-user \
    vagrant \
    vim vim-enhanced \
    wget

# cp config files
rsync -a . ~ --exclude=.git --exclude=setup-machine.sh

# node and npm
sudo dnf install -y nodejs
sudo ln -s /bin/node /usr/local/bin/nodejs
sudo npm install -g javascript-typescript-langserver

# php and composer
sudo dnf install -y php composer
if [ ! -d ~/.config/composer/vendor/felixfbecker/language-server ] ; then
    composer global require felixfbecker/language-server
    composer run-script --working-dir=`realpath ~/.config/composer/vendor/felixfbecker/language-server` parse-stubs
fi

# fzf
if [ ! -d ~/.fzf ] ; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    sudo ln -s ~/.fzf/bin/fzf /usr/local/bin/fzf
fi

# docker and docker-compose (see https://docs.docker.com/install/linux/docker-ce/fedora/)
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-compose
sudo groupadd docker -f
sudo usermod -a -G docker `whoami`
sudo systemctl enable docker

# nvim
if [ ! -d ~/.vim/bundle/Vundle.vim ] ; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

nvim +PluginUpdate +qall
nvim +UpdateRemotePlugins +qall

if [ ! -f ~/.vim/bundle/LanguageClient-neovim/bin/languageclient ] ; then
    pushd ~/.vim/bundle/LanguageClient-neovim
    bash install.sh
    popd
fi

# zsh
sudo dnf install -y zsh
chsh -s /bin/zsh
if [ ! -d ~/.oh-my-zsh ] ; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    rm ~/.zshrc* && cp ./.zshrc ~/.zshrc
fi

# neofetch
sudo dnf copr enable -y konimex/neofetch
sudo dnf install -y neofetch

# gnome
sudo dnf install -y \
    arc-theme \
    chrome-gnome-shell \
    dconf-editor \
    gnome-terminal-nautilus \
    gnome-tweaks \
    numix-icon-theme numix-icon-theme-circle \
    pop-gtk-theme pop-icon-theme \

# graphical apps
sudo dnf install -y \
    audacious \
    audacity \
    brasero \
    chromium chromium-common chromium-libs chromium-libs-media chromium-libs-media-freeworld \
    clementine \
    easytag \
    epiphany \
    gimp \
    gucharmap \
    gparted \
    firefox \
    fontforge \
    inkscape \
    k3b k3b-extras-freeworld \
    libreoffice \
    playonlinux \
    steam \
    thunderbird thunderbird-enigmail \
    vlc \
    tilix \
    transmission-gtk \
    wine \
    wireshark

# settings
sudo usermod -a -G wireshark `whoami`
sudo bash -c "echo 'vm.swappiness=5' >> /etc/sysctl.conf"
# disable tracker miner (see https://askubuntu.com/a/348692)
echo -e "\nHidden=true\n" | sudo tee --append /etc/xdg/autostart/tracker-extract.desktop \
    /etc/xdg/autostart/tracker-miner-apps.desktop \
    /etc/xdg/autostart/tracker-miner-fs.desktop \
    /etc/xdg/autostart/tracker-miner-user-guides.desktop \
    /etc/xdg/autostart/tracker-store.desktop > /dev/null
gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false
tracker reset --hard

# done
sudo reboot
