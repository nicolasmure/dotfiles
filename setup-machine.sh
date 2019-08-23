#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
[[ "${TRACE:-}" != "" ]] && set -o xtrace

# @TODO : make ansible task for chromecast audio installation depending on
#         an env var.

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

################################################################################

install_ansible () {
    sudo dnf install -y \
        ansible \
        pexpect \
        python3
}

provision_localhost () {
    ansible-playbook \
        -i hosts \
        -l localhost \
        playbook.yml \
        --ask-become-pass
}

main () {
    install_ansible

    provision_localhost
}

main
