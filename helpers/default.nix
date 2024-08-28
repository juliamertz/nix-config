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

  getPkgs = branch: branch.legacyPackages.${settings.system.platform};

  isDarwin = settings.system.platform == "aarch64-darwin"; # TODO: Include x86
  isLinux = settings.system.platform == "x86_64-linux"; # TODO: Include arm
}
