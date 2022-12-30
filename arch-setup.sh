#!/usr/bin/env bash

set -eu

pamac install snapd libpamac-snap-plugin
sudo pacman -S curl git jq jenv
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

for pkg in docker ngrok brave 1password signal-desktop spotify vlc skype libreoffice; do
    snap install $pkg
done

for p in cmake intellij-idea-community; do
  snap install $pkg --classic
done
