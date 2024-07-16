{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    protonvpn-gui
    protonvpn-cli
    # protonvpn-cli_2
  ];
  # TODO: Wiregaurd vpn config
}
