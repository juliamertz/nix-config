{
  callPackage,
  lib,
  platform,
}:
let
  inherit (builtins) elem;
in
{
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
}
