{ pkgs, ... }:
{
  config = {
    networking = {
      firewall.enable = true;
    };
    services = {
      # Network shares
      samba = {
        package = pkgs.samba4Full;
        enable = true;
        openFirewall = true;

        extraConfig = ''
          server smb encrypt = required
          server min protocol = SMB3_00
        '';

        shares.media = {
          path = "/home/media";
          writable = "true";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
      };
      avahi = {
        publish.enable = true;
        publish.userServices = true;
        nssmdns4 = true;
        enable = true;
        openFirewall = true;
      };
      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
