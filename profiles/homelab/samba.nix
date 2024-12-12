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

        # extraConfig = ''
        #   server smb encrypt = required
        #   server min protocol = SMB3_00
        # '';

        # settings.media = {
        #   path = "/home/media";
        #   writable = "true";
        #   "create mask" = "0644";
        #   "directory mask" = "0755";
        # };

        settins.media = {
          path = "/home/share";
          public = "yes";
          "guest only" = "yes";
          writable = "yes";
          "force create mode" = "0666";
          "force directory mode" = "0777";
          browseable = "yes";
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
