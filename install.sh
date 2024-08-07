#!/usr/bin/env bash

FLAKE_PATH=$HOME/nix

sudo nixos-generate-config --show-hardware-config > $FLAKE_PATH/hardware-configuration.nix
sudo nixos-rebuild switch --flake $FLAKE_PATH

echo Do not forget to generate age keys for sops!
