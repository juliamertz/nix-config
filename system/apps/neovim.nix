{ pkgs, dotfiles, helpers, ... }:
let
  nvim = helpers.wrapPackage {
    name = "nvim";
    package = pkgs.neovim;
    dependencies = with pkgs; [ ripgrep stdenv.cc nixfmt ];
    extraFlags = "-u ${dotfiles.path}/nvim/init.lua";
    extraArgs = [ "--set XDG_CONFIG_HOME '${dotfiles.path}'" ];
    postWrap = /*sh*/ '' ln -sf $out/bin/nvim $out/bin/vim '';
  };
in {
  environment.systemPackages = [ nvim ];
  # programs.nix-ld.enable = true;
}
