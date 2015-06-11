#!/usr/bin/env bash
set -x

symlink_dotfiles() {
  for src in $(find -maxdepth 2 -name '*.symlink')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    ln -s $(pwd)/$src $dst
  done
}

change_shell_to_zsh() {
  if [ ${SHELL} != '/bin/zsh' ]
  then
    chsh -s /bin/zsh
  fi
}

git submodule update --init
symlink_dotfiles
change_shell_to_zsh
