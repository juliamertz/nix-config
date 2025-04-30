{
  inputs,
  system,
  lib,
  extraPackages ? [],
}: let
  nixpkgs = inputs.nixpkgs-unstable;
  pkgs = nixpkgs.legacyPackages."${system}";

  linuxSystem = builtins.replaceStrings ["darwin"] ["linux"] system;
  linuxPkgs = nixpkgs.legacyPackages."${linuxSystem}";
  dotfiles = inputs.dotfiles.packages.${linuxSystem};
in
  pkgs.dockerTools.buildImage {
    name = "devenv";
    tag = "latest";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths =
        extraPackages
        ++ (with dotfiles; [
          # git
          zsh
          # tmux
          # neovim-minimal
          # lazygit
        ])
        ++ (with linuxPkgs; [
          # sudo-rs
          uutils-coreutils-noprefix
          # findutils
          # netcat
          # lsof
          curl
        ]);
      pathsToLink = ["/bin"];
    };

    config = {
      Cmd = [(lib.getExe dotfiles.tmux)];
    };
  }
