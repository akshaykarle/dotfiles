#!/usr/bin/env bash

symlink_dotfiles() {
  for src in $(find -maxdepth 2 -name '*.symlink')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    if [ $1 == 'force' ]; then
      ln -sf $(pwd)/$src $dst
    else
      ln -sf $(pwd)/$src $dst
    fi
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
    curl https://github.com/powerline/fonts/blob/master/Meslo/Meslo%20LG%20M%20Regular%20for%20Powerline.otf\?raw\=true -o 'Meslo LG M Regular for Powerline.otf'
    mv -f 'Meslo LG M Regular for Powerline.otf' /Library/Fonts/
    if [ ! -d ./oh-my-zsh.symlink/custom/themes/powerlevel9k ]; then
      git clone https://github.com/bhilburn/powerlevel9k.git ./oh-my-zsh.symlink/custom/themes/powerlevel9k
    fi
    chsh -s /bin/zsh
  fi
}

install_ycm() {
  cd  ~/.vim/bundle/YouCompleteMe
  git clean -f
  git pull
  git submodule update --recursive --init
  ./install.py --clang-completer --gocode-completer
  cd -
}

install_vim() {
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim -c ":PluginInstall" -c ":qa"
  install_ycm
}

install_spacemacs() {
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
}

if [ $# == 0 ]; then
  echo 'Setting up everything'
  install_brew
  setup_brew_dependencies
  git submodule update --init
  symlink_dotfiles
  change_shell_to_zsh
  install_vim
  install_spacemacs
elif [ $1 == 'symlink' ]; then
  echo 'Recreating dotfiles'
  symlink_dotfiles 'force'
fi
