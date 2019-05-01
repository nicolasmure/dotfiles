#!/bin/bash

# go to the dir of this script
cd "$(dirname "$0")" || exit 1

# remove unneeded things
sudo dnf remove -y \
    evolution \
    rhythmbox

# basic update
sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf upgrade -y --best --allowerasing

# CLI tools
sudo dnf install -y \
    ansible \
    curl \
    dnf-plugins-core \
    gcc \
    git \
    jq \
    make \
    neovim \
    nmap \
    powerline \
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

# install git-standup
curl -L https://raw.githubusercontent.com/kamranahmedse/git-standup/master/installer.sh | sudo sh

# node and npm
sudo dnf install -y nodejs
sudo ln -s /bin/node /usr/local/bin/nodejs
sudo npm install -g javascript-typescript-langserver

# php and composer
sudo dnf install -y php composer
if [ ! -d ~/.config/composer/vendor/felixfbecker/language-server ] ; then
    composer global require felixfbecker/language-server
    composer run-script --working-dir="$(realpath ~/.config/composer/vendor/felixfbecker/language-server)" parse-stubs
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
sudo usermod -a -G docker "$(whoami)"
sudo systemctl enable docker

# nvim
if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ] ; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

nvim +PlugUpgrade +qall
nvim +PlugUpdate +qall
nvim +UpdateRemotePlugins +qall

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
    mediawriter \
    playonlinux \
    steam \
    thunderbird thunderbird-enigmail \
    vlc \
    tilix \
    transmission-gtk \
    wine \
    wireshark

# chromecast audio
install_chromecast_audio () {
    sudo dnf copr enable -y bugzy/mkchromecast
    sudo dnf install -y \
        ffmpeg \
        mkchromecast

    # as pulseaudio starts in userland, do not use systemd but desktop session
    # instead to start pulseaudio-dlna
    mkdir -p ~/.config/autostart
    echo "[Desktop Entry]
Type=Application
Name=mkchromecast
Exec=/usr/bin/mkchromecast -p 10291 --encoder-backend ffmpeg -c wav --sample-rate 44100 --chunk-size 1
" > ~/.config/autostart/mkchromecast.desktop
}

echo "Do you want to install chromecast audio ?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_chromecast_audio; break;;
        No ) break;;
    esac
done

# xbox controller
sudo modprobe xpad

# settings
sudo usermod -a -G wireshark "$(whoami)"
echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf
# disable tracker miner (see https://askubuntu.com/a/348692)
echo -e "\\nHidden=true\\n" | sudo tee -a /etc/xdg/autostart/tracker-extract.desktop \
    /etc/xdg/autostart/tracker-miner-apps.desktop \
    /etc/xdg/autostart/tracker-miner-fs.desktop \
    /etc/xdg/autostart/tracker-miner-user-guides.desktop \
    /etc/xdg/autostart/tracker-store.desktop > /dev/null
gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false
tracker reset --hard

# done
sudo reboot
