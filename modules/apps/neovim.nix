{ pkgs, inputs, dotfiles, helpers, settings, ... }:
let
  nvim = helpers.wrapPackage {
    name = "nvim";
    package = (helpers.getPkgs inputs.nixpkgs-unstable).neovim;
    dependencies = with pkgs; [ ripgrep stdenv.cc nixfmt ];
     extraFlags = "-u ${dotfiles.path}/nvim/init.lua";
    extraArgs = [ "--set XDG_CONFIG_HOME '${dotfiles.path}'" "--argv0 'nvim'" ];
    postWrap = # sh
      "ln -sf $out/bin/nvim $out/bin/vim ";
  };
in {
  environment.systemPackages = [ nvim ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ stdenv.cc.cc ];
  };
}
