{pkgs, ...}: {
  config = {
    networking = {
      firewall.enable = true;
    };
    services = {
      # Network shares
      samba = {
        package = pkgs.samba4Full;
        enable = false;
        openFirewall = true;

        # extraConfig = ''
        #   server smb encrypt = required
        #   server min protocol = SMB3_00
        # '';

        settings.media = {
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
        enable = false;
        openFirewall = true;
      };
      samba-wsdd = {
        enable = false;
        openFirewall = true;
      };
    };
  };
}
