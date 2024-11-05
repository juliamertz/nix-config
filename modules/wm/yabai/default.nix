{
  inputs,
  helpers,
  dotfiles,
  ...
}:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
in
{
  # environment.systemPackages = with pkgs; [
  #   
  # ]; 

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;
    extraConfig = builtins.readFile "${dotfiles.path}/yabai/yabairc";
  };

  environment.systemPackages = with pkgs; [ skhd ];

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = builtins.readFile "${dotfiles.path}/skhd/skhdrc";
  };

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
  };
}
