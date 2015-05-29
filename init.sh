#!/usr/bin/env bash
set -x

symlink_dotfiles() {
  for src in $(find -maxdepth 2 -name '*.symlink')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    ln -s $(pwd)/$src $dst
  done
}

symlink_dotfiles
