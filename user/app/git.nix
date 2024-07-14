{ pkgs, settings, ... }:
{
  # home.packages = with pkgs; [ git gh ];

  programs.git = {
    enable = true;
    userName = settings.user.fullName;
    userEmail = settings.user.email;

    aliases = {
      s = "status";
    };

  };
}
