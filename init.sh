#!/usr/bin/env bash
set -x

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

change_shell_to_zsh() {
  if [ ${SHELL} != '/bin/zsh' ]
  then
    install_zsh
    chsh -s /bin/zsh
  fi
}

git submodule update --init
symlink_dotfiles
change_shell_to_zsh
