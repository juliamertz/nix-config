#!/usr/bin/env bash

FLAKE_PATH=$HOME/nix

sudo nixos-generate-config --show-hardware-config > $FLAKE_PATH/hardware/generated.nix
# sudo nixos-rebuild switch --flake $FLAKE_PATH#workstation
# nix-shell -p nh --commmand "nh home switch $FLAKE_PATH#julia"


