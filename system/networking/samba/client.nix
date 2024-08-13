{ pkgs, lib, config, helpers, settings, ... }:
let user = settings.user.username;
in {
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/media" = {
    device = "//192.168.0.100/media";
    fsType = "cifs";
    options = [
      "credentials=${config.sops.templates."smb-secrets".path}"
      # "soft"
      # "softreval"
      # "timeo=100"
      # "noatime"
      # "nodiratime"
      # "noauto" 
      "x-systemd.automount" 
      # "_netdev" 
      # "x-systemd.mount-timeout=5"
      # "x-systemd.idle-timeout=3600"
    ];
  };

  sops.secrets =
    helpers.ownedSecrets user [ "samba_username" "samba_password" ];

  sops.templates."smb-secrets".content = ''
    username=${config.sops.placeholder.samba_username}
    password=${config.sops.placeholder.samba_password}
  '';

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  services.gvfs.enable = true;
}
