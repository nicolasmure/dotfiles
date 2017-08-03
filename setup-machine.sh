#!/bin/bash

# basic update
sudo dnf upgrade
# install the basics
sudo dnf install git vim neovim

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
sudo ln -s ~/.fzf/bin/fzf-tmux /usr/local/bin/fzf-tmux

sudo dnf install ruby ruby-devel gcc redhat-rpm-config vim-enhanced
gem install neovim
sudo pip3 install --upgrade neovim
sudo pip3 install --upgrade typing
