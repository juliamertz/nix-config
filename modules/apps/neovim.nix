{ inputs, dotfiles, helpers, settings, ... }:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
  nvim = helpers.wrapPackage {
    name = "nvim";
    package = pkgs.neovim;
    dependencies = with pkgs; [ ripgrep stdenv.cc nixfmt nil ];
    extraFlags = "-u ${dotfiles.path}/nvim/init.lua";
    extraArgs = [ "--set XDG_CONFIG_HOME '${dotfiles.path}'" "--argv0 'nvim'" ];
    postWrap = # sh
      "ln -sf $out/bin/nvim $out/bin/vim ";
  };
in {
  environment.systemPackages = [ nvim pkgs.nvimpager ];

  # TODO: Seperate into nixos specific
  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [ stdenv.cc.cc ];
  # };
}
