{
  config,
  lib,
  ...
}: let
  cfg = config.openssh;
in {
  options = with lib; {
    openssh = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      setupHosts = mkOption {
        type = types.bool;
        default = true;
      };
      harden = mkOption {
        type = types.bool;
        default = false;
      };
      # hosts = {
      #   type = types.attrsOf (
      #     types.submodule {
      #       options = {
      #         name = mkOption {
      #           type = types.str;
      #           default = null;
      #         };
      #         hostName = mkOption {
      #           type = types.str;
      #           default = null;
      #         };
      #         user = mkOption {
      #           type = types.str;
      #           default = null;
      #         };
      #         port = mkOption {
      #           type = types.port;
      #           default = 22;
      #         };
      #       };
      #     }
      #   );
      # };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh.extraConfig =
      lib.optionalString cfg.setupHosts
      # sh
      ''
        Match exec "ping -c1 -W1 192.168.0.1 >/dev/null 2>&1"
          Host orion
            HostName 192.168.0.101
            User julia
            Port 22
          Host hydra
            HostName 192.168.0.100
            User julia
            Port 22
          Host pegasus
            HostName 192.168.0.236
            User julia
            Port 22

        Match all
          Host orion
            HostName 172.27.21.207
            User julia
            Port 22
          Host hydra
            HostName 172.27.215.56
            User julia
            Port 22
          Host pegasus
            HostName 172.27.129.242
            User julia
            Port 22
          Host andromeda
            HostName 188.245.65.183
            User julia
            Port 22

      '';

    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.fail2ban.enable = cfg.harden;

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
