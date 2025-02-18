{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.home-assistant;
  includeThemes = builtins.length cfg.customThemes > 0;
  optional = cond: val: if cond then val else "";
in
{
  options.services.home-assistant = with lib; {
    customThemes = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (import ./overlays.nix)
    ];

    services.home-assistant.config = {
      # FIX: themes are only working if we include all yaml files in the root theme directory,
      # this option is still necessary but doesn't seem to change that. for now copying theme files directly works
      frontend.themes = lib.mkIf includeThemes "!include_dir_merge_named themes";
    };

    systemd.services.home-assistant.serviceConfig = lib.mkIf includeThemes {
      ExecStartPre =
        let
          linkThemes = # sh
            ''
              mkdir -p ${cfg.configDir}/themes;
              packages=(${lib.concatStringsSep " " cfg.customThemes})

              for package in "''${packages[@]}"; do
                ln -fns $package/themes/*/*.yaml ${cfg.configDir}/themes
              done
            '';
        in
        (optional includeThemes linkThemes)
        |> pkgs.writeShellScriptBin "home-assistant-extra-prestart"
        |> lib.getExe;
    };
  };
}
