#!/usr/bin/env bash

FLAKE_PATH=$HOME/nix

if [[ $OSTYPE == 'darwin'* ]]; then
  nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .
else
  sudo nixos-generate-config --show-hardware-config > $FLAKE_PATH/hardware-configuration.nix
  sudo nixos-rebuild switch --flake $FLAKE_PATH#$1
  nix run home-manager/master --extra-experimental-features "nix-command flakes" -- switch --flake $FLAKE_PATH#julia
fi


