{ pkgs, lib, config, helpers, settings, ... }:
let user = settings.user.username;
in {
  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems."/mnt/media" = {
    device = "//192.168.0.100/media";
    fsType = "cifs";
    options = let
      automount_opts =
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [
      "${automount_opts},credentials=${
        config.sops.templates."smb-secrets".path
      }"
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
