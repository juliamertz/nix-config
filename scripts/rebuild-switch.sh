#!/usr/bin/env sh

FLAKE=$(dirname $0/../)
KERNEL=$(uname -s)
PROFIlE=$1

if [[ $KERNEL == "Linux" ]]; then
  sudo nixos-rebuild switch --flake $FLAKE#$PROFILE

elif [[ $KERNEL == "Darwin" ]]; then
  nix run --extra-experimental-features "nix-command flakes" \
    nix-darwin -- switch --flake $FLAKE#$PROFILE
fi
