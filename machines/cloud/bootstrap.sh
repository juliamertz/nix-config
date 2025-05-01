#!/usr/bin/env sh

sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode destroy,format,mount ./disks.nix
# --yes-wipe-all-disks 
