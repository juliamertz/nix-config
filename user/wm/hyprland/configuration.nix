{ config, ... }:
{
  # services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "hyprland";
  programs.hyprland.enable = true;
}
