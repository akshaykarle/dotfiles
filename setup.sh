#!/usr/bin/env bash

symlink_dotfiles() {
  for src in $(find -maxdepth 2 -name '*.symlink')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    ln -s $(pwd)/$src $dst
  done
}

install_zsh() {
  if [ -n "$(command -v yum)" ]
  then
    sudo yum install -y zsh
  elif [ -n "$(command -v apt-get)" ]
  then
    sudo apt-get install -y zsh
  elif [ -n "$(command -v dnf)" ]
  then
    sudo dnf install -y zsh
  fi
}

install_brew() {
  if [ -n "$(uname | grep 'Darwin')" ]
  then
    which brew > /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

setup_brew_dependencies() {
  if [ -n "$(command -v brew)" ]
  then
    brew tap Homebrew/bundle
    brew bundle
  fi
}

change_shell_to_zsh() {
  if [ ${SHELL} != '/bin/zsh' ]
  then
    install_zsh
    chsh -s /bin/zsh
  fi
}

install_brew
setup_brew_dependencies
git submodule update --init
symlink_dotfiles
change_shell_to_zsh

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c ":PluginInstall"
