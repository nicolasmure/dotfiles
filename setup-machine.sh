#!/bin/bash

sudo dnf upgrade
sudo dnf install nodejs
sudo ln -s /bin/node /usr/local/bin/nodejs
sudo npm install -g javascript-typescript-langserver

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sudo dnf install ruby ruby-devel gcc redhat-rpm-config vim-enhanced
gem install neovim
