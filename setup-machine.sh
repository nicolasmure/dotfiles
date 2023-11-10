#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
[[ "${TRACE:-}" != "" ]] && set -o xtrace

install_ansible () {
    sudo dnf install -y \
        ansible \
        python3
}

copy_dist_files () {
    if [ ! -f vars/localhost.yml ]
    then
        cp vars/localhost.yml.dist vars/localhost.yml
    fi
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

    copy_dist_files

    provision_localhost
}

main
