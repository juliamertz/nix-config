{
  callPackage,
  lib,
  system,
}:
let
  inherit (builtins) elem;
in
rec {
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

  getPkgs = branch: branch.legacyPackages.${system};

  isDarwin = elem system [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  isLinux = elem system [
    "aarch64-linux"
    "x86_64-linux"
  ];

  perPlatform = modules: if isDarwin then modules.darwin else modules.linux;
}
