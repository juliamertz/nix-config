{
  inputs,
  pkgs,
  lib,
  linuxPlatform ? "x86_64-linux",
  pkgsLinux ? import inputs.nixpkgs-unstable {system = linuxPlatform;},
  extraPackages ? [],
}: let
  dotfiles = inputs.dotfiles.packages.x86_64-linux;
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
          neovim-minimal
          lazygit
        ])
        ++ (with pkgsLinux; [
          findutils
          netcat
          lsof
          curl
        ]);
      pathsToLink = ["/bin"];
    };

    config = {
      Cmd = [(lib.getExe dotfiles.zsh)];
    };
  }
