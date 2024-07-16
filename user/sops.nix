{ pkgs, inputs, settings, lib, config, ...}:
let 
  format = "yaml";
  cfg = config.secrets;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.secrets = {
    profile = lib.mkOption {
      type = lib.types.str;
      default = settings.system.username;
    };
    format = lib.mkOption {
      type = lib.types.str;
      default = "yaml";
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
  };
}
