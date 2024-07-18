{ lib, pkgs, config, ... }:
let 
  cfg = config.affinity;
  script = /*bash*/''
    # https://github.com/lf-/affinity-crimes/blob/main/affinity.sh
    (return 0 2>/dev/null) && sourced=1 || sourced=0
    ${cfg.env}

    if [[ $sourced == 0 ]]; then exec "$@"; fi
  '';
in {
  nixpkgs.config.packageOverrides = pkgs: {
    affinity = (pkgs.writeShellScriptBin "affinity" script);
  };
}
