{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nil
    nixd
    nixfmt-rfc-style
  ];
}
