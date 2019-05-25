#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
[[ "${TRACE:-}" != "" ]] && set -o xtrace

printerr () {
    echo "${@}" >&2
}

check_sudo () {
    if [ "0" != "$(id -u)" ]; then
        printerr "Please run this script with sudo : sudo <script>"

        exit 1
    fi
}

check_sudo_user () {
    if [ "root" = "${SUDO_USER}" ]; then
        printerr "The sudoer must not be root. Log in as a non root user and run this script with : sudo <script>"

        exit 1
    fi
}

set_user_home_var () {
    USER_HOME="$(getent passwd "${SUDO_USER}" | cut -d":" -f 6)"
}

go_to_script_dir () {
    cd "$(dirname "$0")"
}

copy_config_files () {
    sudo -u "${SUDO_USER}" rsync -a . "${USER_HOME}" --exclude=.git --exclude=setup-machine.sh
}

remove_uneeded_packages () {
    dnf remove -y \
        evolution \
        rhythmbox
}

basic_update () {
    dnf install -y \
        "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    dnf upgrade -y --best --allowerasing
}

install_cli_tools () {
    dnf install -y \
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
}

install_zsh () {
    dnf install -y zsh
    sudo -u "${SUDO_USER}" chsh -s /bin/zsh
    if [ ! -d "${USER_HOME}/.oh-my-zsh" ] ; then
        sudo -u "${SUDO_USER}" sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

        if [ "$(find "${USER_HOME}" -maxdepth 1 -type f -name ".zshrc*" | wc -l)" -gt "0" ]; then
            rm "${USER_HOME}/.zshrc*"
        fi

        sudo -u "${SUDO_USER}" cp ./.zshrc "${USER_HOME}/.zshrc"
    fi
}

install_neofetch () {
    dnf copr enable -y konimex/neofetch
    dnf install -y neofetch
}

install_git_standup () {
    curl -L https://raw.githubusercontent.com/kamranahmedse/git-standup/master/installer.sh | sh
}

install_fzf () {
    if [ ! -d "${USER_HOME}/.fzf" ] ; then
        sudo -u "${SUDO_USER}" git clone --depth 1 https://github.com/junegunn/fzf.git "${USER_HOME}/.fzf"
        sudo -u "${SUDO_USER}" "${USER_HOME}/.fzf/install"
        ln -s "${USER_HOME}/.fzf/bin/fzf" /usr/local/bin/fzf
    fi
}

install_nodejs () {
    dnf install -y nodejs
    ln -s /bin/node /usr/local/bin/nodejs
    npm install -g \
        javascript-typescript-langserver \
        yarn
}

install_php () {
    dnf install -y php composer

    if [ ! -d "${USER_HOME}/.config/composer/vendor/felixfbecker/language-server" ] ; then
        sudo -u "${SUDO_USER}" composer global require felixfbecker/language-server
        sudo -u "${SUDO_USER}" composer run-script --working-dir="${USER_HOME}/.config/composer/vendor/felixfbecker/language-server" parse-stubs
    fi
}


install_docker () {
    # the docker-ce package is now shipped by moby-engine package on fedora
    # see https://github.com/docker/for-linux/issues/600#issuecomment-495894108
    dnf install -y moby-engine docker-compose
    groupadd docker -f
    usermod -a -G docker "${SUDO_USER}"
    systemctl enable docker
}

configure_nvim () {
    if [ ! -f "${USER_HOME}/.local/share/nvim/site/autoload/plug.vim" ] ; then
        sudo -u "${SUDO_USER}" \
            curl -fLo "${USER_HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    sudo -u "${SUDO_USER}" nvim +PlugUpgrade +qall
    sudo -u "${SUDO_USER}" nvim +PlugUpdate +qall
    sudo -u "${SUDO_USER}" nvim +UpdateRemotePlugins +qall
}

install_gnome_deps () {
    dnf install -y \
        arc-theme \
        chrome-gnome-shell \
        dconf-editor \
        gnome-terminal-nautilus \
        gnome-tweaks \
        numix-icon-theme numix-icon-theme-circle
}

install_graphical_apps () {
    dnf install -y \
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

    usermod -a -G wireshark "${SUDO_USER}"
}

install_chromecast_audio () {
    dnf copr enable -y bugzy/mkchromecast
    dnf install -y \
        ffmpeg \
        mkchromecast

    # as pulseaudio starts in userland, do not use systemd but desktop session
    # instead to start pulseaudio-dlna
    sudo -u "${SUDO_USER}" mkdir -p "${USER_HOME}/.config/autostart"
    echo "[Desktop Entry]
Type=Application
Name=mkchromecast
Exec=/usr/bin/mkchromecast -p 10291 --encoder-backend ffmpeg -c wav --sample-rate 44100 --chunk-size 1
" | sudo -u "${SUDO_USER}" tee -a "${USER_HOME}/.config/autostart/mkchromecast.desktop"
}

prompt_for_chromecast_audio_installation () {
    echo "Do you want to install chromecast audio ?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) install_chromecast_audio; break;;
            No ) break;;
        esac
    done
}

enable_xbox_controller_kernel_module () {
    modprobe xpad
}

configure_swappiness () {
    echo "vm.swappiness=5" | tee -a /etc/sysctl.conf
}

disable_tracker_miner () {
    # see https://askubuntu.com/a/348692
    echo -e "\\nHidden=true\\n" | tee -a /etc/xdg/autostart/tracker-extract.desktop \
        /etc/xdg/autostart/tracker-miner-apps.desktop \
        /etc/xdg/autostart/tracker-miner-fs.desktop \
        /etc/xdg/autostart/tracker-miner-user-guides.desktop \
        /etc/xdg/autostart/tracker-store.desktop > /dev/null
    sudo -u "${SUDO_USER}" gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
    sudo -u "${SUDO_USER}" gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false
    sudo -u "${SUDO_USER}" tracker reset --hard
}

main () {
    check_sudo
    check_sudo_user
    set_user_home_var
    go_to_script_dir

    copy_config_files

    remove_uneeded_packages
    basic_update

    install_cli_tools
    install_zsh
    install_neofetch
    install_git_standup
    install_fzf

    install_nodejs
    install_php
    install_docker

    configure_nvim

    install_gnome_deps
    install_graphical_apps

    prompt_for_chromecast_audio_installation

    enable_xbox_controller_kernel_module

    configure_swappiness
    disable_tracker_miner

    # done
    reboot
}

main
