#!/usr/bin/env sh

# sudo nix --experimental-features "nix-command flakes" \
#   run github:nix-community/disko/latest -- \
#   --yes-wipe-all-disks \
#   --mode destroy,format,mount ./disks.nix
 

VPS="gatekeeper"

nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config "./machines/cloud/$VPS/hardware.nix" \
  --disko-mode disko \
  --flake ".#$VPS" --target-host root@116.203.24.1
