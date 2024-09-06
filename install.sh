#!/usr/bin/env sh

FLAKE=$(dirname $0)
SSH_KEY=~/.ssh/id_ed25519

if [ -f $SSH_KEY ]; then
  nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i $SSH_KEY > ~/.config/sops/age/keys.txt"
else 
  echo No ssh key found, skipping age key generation.
fi


KERNEL=$(uname -s)

if [[ $KERNEL == "Linux" ]]; then
  # sudo nixos-generate-config --show-hardware-config > $FLAKE/hardware-configuration.nix
  sudo nixos-rebuild switch --flake $FLAKE

elif [[ $KERNEL == "Darwin" ]]; then
  nix run --extra-experimental-features "nix-command flakes" \
    nix-darwin -- switch --flake $FLAKE
fi
