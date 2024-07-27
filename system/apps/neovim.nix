{ pkgs, dotfiles, helpers, ... }:
let
  nvim = helpers.wrapPackage {
    name = "nvim";
    package = pkgs.neovim;
    dependencies = with pkgs; [ ripgrep stdenv.cc ];
    extraFlags = "-u ${dotfiles.path}/nvim/init.lua";
    preWrap = /*sh*/ ''
      # Enable dynamically linked mason lsp binaries
      NIX_LD=$(<${pkgs.stdenv.cc}/nix-support/dynamic-linker)
    '';
    extraArgs =  [
      "--set NIX_LD $NIX_LD"
      "--set XDG_CONFIG_HOME '${dotfiles.path}'"
    ];
    postWrap = /*sh*/ ''
      ln -sf $out/bin/nvim $out/bin/vim
    '';
  };
in
{
  environment.systemPackages = [ nvim ];
  programs.nix-ld.enable = true;
}
