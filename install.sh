#!/usr/bin/env bash

FLAKE_PATH=$HOME/nix

sudo nixos-generate-config --show-hardware-config > $FLAKE_PATH/hardware-configuration.nix
sudo nixos-rebuild switch --flake $FLAKE_PATH#$1
#nix-shell -p nh --commmand "nh home switch $FLAKE_PATH#julia"
nix run home-manager/master --extra-experimental-features "nix-command flakes" -- switch --flake $FLAKE_PATH#julia


