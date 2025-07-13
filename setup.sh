#!/bin/sh

case $(uname) in
  Linux)  sudo dnf -y copr enable atim/starship
          sudo dnf -y install starship
          ;;
  Darwin) brew install bash coreutils starship
          ;;
esac
