{ callPackage }: {
  wrapPackage = callPackage ./wrap-package.nix { };
  ownedSecrets = owner: keys:
    builtins.listToAttrs (map (key: {
      name = key;
      value = { inherit owner; };
    }) keys);
}
