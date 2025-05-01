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
          git
          zsh
          tmux
          neovim-minimal
        ])
        ++ (with linuxPkgs; [
          sudo-rs
          uutils-coreutils-noprefix
          findutils
          netcat
          lsof
          curl
        ]);
      pathsToLink = ["/bin"];
    };

    config = let
      shell = cmd: [(lib.getExe dotfiles.zsh) "-c" cmd];
    in {
      Cmd = shell "TMUX_TMPDIR=/ tmux";
    };
  }
