{ config, lib, ... }:
let cfg = config.openssh;
in {
  options = with lib; {
    openssh = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      harden = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = lib.mkIf cfg.harden {
        UsePAM = false;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
