#!/bin/bash

# basic update
sudo dnf upgrade
# install the basics
sudo dnf install git vim neovim tilix \
    gnome-terminal-nautilus # add a "Open in terminal" shortcut on right click

# node and npm
sudo dnf install nodejs
sudo ln -s /bin/node /usr/local/bin/nodejs
sudo npm install -g javascript-typescript-langserver

# php and composer
sudo dnf install php composer
composer global require felixfbecker/language-server
composer run-script --working-dir=`realpath ~/.config/composer/vendor/felixfbecker/language-server` parse-stubs

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
sudo ln -s ~/.fzf/bin/fzf /usr/local/bin/fzf

sudo dnf install python3 python3-devel ruby ruby-devel gcc redhat-rpm-config vim-enhanced ShellCheck jq
gem install neovim
pip3 install --user --upgrade neovim typing jedi mistune psutil setproctitle

# docker and docker-compose
sudo dnf install docker-ce docker-compose
sudo groupadd docker -f
sudo usermod -a -G docker nicolas
sudo systemctl enable docker
