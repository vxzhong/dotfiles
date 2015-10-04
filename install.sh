#! /bin/bash

ln -s $(pwd)/vimrc ~/.vimrc
[[ -d ~/.vim ]] || mkdir -p ~/.vim
ln -s $(pwd)/zshrc ~/.zshrc
ln -s $(pwd)/gitconfig ~/.gitconfig
