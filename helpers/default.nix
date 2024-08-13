{ callPackage, lib, settings }: {
  wrapPackage = callPackage ./wrap-package.nix { };

  ownedSecrets = owner: keys:
    builtins.listToAttrs (map (key: {
      name = key;
      value = { inherit owner; };
    }) keys);

  formattedEnvVars = envVars:
    let formatEnvVar = name: value: "--set ${name} '${value}'";
    in lib.concatStringsSep " " (lib.mapAttrsToList formatEnvVar envVars);

  getPkgs = branch: branch.legacyPackages.${settings.system.platform}.neovim;
}
