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

# chromecast audio
function install_chromecast_audio () {
    sudo pip install vext
    sudo pip install vext.gi
    sudo dnf copr enable -y cygn/pulseaudio-dlna
    sudo dnf install -y \
        pulseaudio-dlna \
        python2-gobject \
        python2-gtkextra

    # as pulseaudio starts in userland, do not use systemd but desktop session
    # instead to start pulseaudio-dlna
    mkdir -p ~/.config/autostart
    echo "[Desktop Entry]
Type=Application
Name=pulseaudio-dlna
Exec=/usr/bin/pulseaudio-dlna -c wav -p 10291 --auto-reconnect
" > ~/.config/autostart/pulseaudio-dlna.desktop

    # also install pulse effects to have a limiter
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install -y flathub com.github.wwmm.pulseeffects
}

echo "Do you want to install chromecast audio ?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_chromecast_audio; break;;
        No ) break;;
    esac
done

# settings
sudo usermod -a -G wireshark `whoami`
echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf
# disable tracker miner (see https://askubuntu.com/a/348692)
echo -e "\nHidden=true\n" | sudo tee -a /etc/xdg/autostart/tracker-extract.desktop \
    /etc/xdg/autostart/tracker-miner-apps.desktop \
    /etc/xdg/autostart/tracker-miner-fs.desktop \
    /etc/xdg/autostart/tracker-miner-user-guides.desktop \
    /etc/xdg/autostart/tracker-store.desktop > /dev/null
gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false
tracker reset --hard

# done
sudo reboot
