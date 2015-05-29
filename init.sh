#!/usr/bin/env bash
set -x

symlink_dotfiles() {
  for src in $(find -d *.symlink)
  do
    dst="$HOME/.$(basename "${src%.*}")"
    ln -s $(pwd)/$src $dst
  done
}

symlink_dotfiles
