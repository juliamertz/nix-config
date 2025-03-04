# update addons by running this command:
# nix run github:stnley/mozilla-addons-to-nix extra-addons.json extra-addons.nix
{
  inputs,
  stdenv,
  fetchurl,
  system,
  callPackage,
  ...
}:
let
  buildFirefoxXpiAddon =
    {
      pname,
      meta,
      version,
      addonId,
      url,
      sha256,
      ...
    }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";
      src = fetchurl { inherit url sha256; };
      preferLocalBuild = true;
      allowSubstitutes = true;
      passthru = { inherit addonId; };
      inherit meta;
      buildCommand =
        # sh
        ''
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -v -m644 "$src" "$dst/${addonId}.xpi"
        '';
    };

in
inputs.firefox-addons.packages.${system}
// callPackage ./extra-addons.nix { inherit buildFirefoxXpiAddon; }
