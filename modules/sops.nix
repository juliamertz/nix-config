{
  pkgs,
  inputs,
  settings,
  lib,
  config,
  ...
}:
let
  format = "yaml";
  cfg = config.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.secrets = {
    profile = lib.mkOption {
      type = lib.types.str;
      default = "personal";
    };
    format = lib.mkOption {
      type = lib.types.str;
      default = "yaml";
    };
    activationScript = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  # Secrets attribute should be set in per-profile configuration
  config = {
    environment.systemPackages = [ pkgs.sops ];
    sops = {
      defaultSopsFile = ../secrets/${cfg.profile}.${cfg.format};
      defaultSopsFormat = format;
      age.keyFile = "${settings.user.home}/.config/sops/age/keys.txt";
    };

    # If age keys are stored on a file-system that is mounted later in the boot process
    # secrets won't be put in /run/secrets, this works around this issue.
    # https://github.com/Mic92/sops-nix/issues/149#issuecomment-1656036132
    systemd.services.decrypt-sops = lib.mkIf cfg.activationScript {
      description = "Decrypt sops secrets";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "2s";
      };
      script = config.system.activationScripts.setupSecrets.text;
    };
  };
}
