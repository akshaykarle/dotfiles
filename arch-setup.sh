#!/usr/bin/env bash

set -eu

pamac install snapd libpamac-snap-plugin
# sudo pacman -Sy rbenv
sudo systemctl enable --now snapd.socket
if [ ! -d /snap ]
then
    ln -s /var/lib/snapd/snap /snap
fi

pamac install \
      tmux fish openssl nmap jq \
      vim emacs \
      terraform \
      aws-cli \
      go nodejs clojure leiningen python python-poetry

snap refresh

sudo snap set system experimental.parallel-instances=true

snap install \
     docker ngrok brave 1password signal-desktop spotify vlc

snap install intellij-idea-community --classic
