{
  pkgs,
  settings,
  ...
}:
let
  inherit (settings.user) username;
in
{
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
  programs.virt-manager = {
    enable = true;
    package = pkgs.virt-manager;
  };

  users.users.${username} = {
    extraGroups = [ "libvirtd" ];
  };
}
