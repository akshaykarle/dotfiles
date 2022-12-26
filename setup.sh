#!/usr/bin/env bash

symlink_dotfiles() {
  for src in $(gfind -maxdepth 2 -name '*.symlink')
  do
    if [[ $src = *fish* ]] # fish files are special and live in $HOME/.config/fish/
    then
      dst="$HOME/.config/fish/$(basename "${src%.*}")"
      ln -sf $(pwd)/$src $dst
    else
      dst="$HOME/.$(basename "${src%.*}")"
      ln -sf $(pwd)/$src $dst
    fi
  done
}

install_fisher() {
  fish -c "fisher" || fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
  fish -c "fisher update; fish_update_completions"
}

install_fish() {
  if [ -n "$(command -v yum)" ]
  then
    sudo yum install -y fish
  elif [ -n "$(command -v apt-get)" ]
  then
    sudo apt-get install -y fish
  elif [ -n "$(command -v dnf)" ]
  then
    sudo dnf install -y fish
  elif [ -n "#(command -v pamac)" ]
  then
    pamac install fish
  fi
}

change_shell_to_fish() {
    if [[ ! ${SHELL} = *fish* ]]
    then
        install_fish
        if [ -n "$(uname | grep 'Darwin')" ]
        then
            echo /usr/local/bin/fish | sudo tee -a /etc/shells
            chsh -s /usr/local/bin/fish
        else
            chsh -s /usr/bin/fish
        fi
    fi

    install_fisher
}

install_brew() {
  if [ -n "$(uname | grep 'Darwin')" ]
  then
    which brew > /dev/null || bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

setup_brew_dependencies() {
  if [ -n "$(command -v brew)" ]
  then
    xcode-select --install
    softwareupdate --all --install --force

    brew tap Homebrew/bundle
    brew bundle
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
  if [ -n "$(uname | grep 'Darwin')" ]
  then
    ln -sf /usr/local/Cellar/emacs-plus/*/Emacs.app/ /Applications/
  fi
}

install_arch_dependencies() {
  if [ -n "$(command -v pamac)" ]
  then
    sh arch-setup.sh
  fi
}

if [ $# == 0 ]; then
  echo 'Setting up everything'
  install_arch_dependencies
  install_brew
  setup_brew_dependencies
  git submodule update --init
  change_shell_to_fish
  symlink_dotfiles
  install_vim
  install_spacemacs
elif [ $1 = 'symlink' ]; then
  echo 'Recreating dotfiles'
  symlink_dotfiles
elif [ $1 = 'fish' ]; then
  echo 'Resetting fish shell'
  change_shell_to_fish
fi
