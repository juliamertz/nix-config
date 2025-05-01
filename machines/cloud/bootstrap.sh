#!/usr/bin/env sh

# sudo nix --experimental-features "nix-command flakes" \
#   run github:nix-community/disko/latest -- \
#   --yes-wipe-all-disks \
#   --mode destroy,format,mount ./disks.nix
 

nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config ./machines/cloud/hardware.nix \
  --flake .#gatekeeper --target-host root@116.203.24.1
