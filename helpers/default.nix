{
  callPackage,
  lib,
  platform,
}:
let
  inherit (builtins) elem;
in
rec {
  wrapPackage = callPackage ./wrap-package.nix { };

  ownedSecrets =
    owner: keys:
    builtins.listToAttrs (
      map (key: {
        name = key;
        value = {
          inherit owner;
        };
      }) keys
    );

  formattedEnvVars =
    envVars:
    let
      formatEnvVar = name: value: "--set ${name} '${value}'";
    in
    lib.concatStringsSep " " (lib.mapAttrsToList formatEnvVar envVars);

  getPkgs = branch: branch.legacyPackages.${platform};

  isDarwin = elem platform [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  isLinux = elem platform [
    "aarch64-linux"
    "x86_64-linux"
  ];

  perPlatform = modules: if isDarwin then modules.darwin else modules.linux;
}
