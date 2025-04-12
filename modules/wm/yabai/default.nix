{
  pkgs,
  dotfiles,
  ...
}: {
  # Window manager
  services.yabai = {
    enable = true;
    extraConfig = builtins.readFile "${dotfiles.path}/yabai/yabairc";

    # Requires system integrity protection to be disabled
    # https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
    enableScriptingAddition = true;
  };

  # Hotkey daemon
  services.skhd = {
    enable = true;
    package = dotfiles.pkgs.skhd;
  };

  # Status bar
  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
  };
}
