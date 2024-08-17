{ config, lib, pkgs, ... }:
let
  cfg = config.services.qbittorrent;

  toString = value:
    if lib.isBool value then
      if value then "true" else "false"
    else
      builtins.toString value;

  replaceDashes = str:
    lib.strings.stringAsChars (x: if x == "-" then "\\" else x) str;

  formatSection = sectionName: sectionAttrs: ''
    [${sectionName}]
    ${lib.concatMapStringsSep "\n"
    (name: "${replaceDashes name}=${toString sectionAttrs.${name}}")
    (lib.attrNames sectionAttrs)}
  '';

  formatAttrset = attrs:
    lib.concatStringsSep "\n" (lib.mapAttrsToList
      (sectionName: sectionAttrs: formatSection sectionName sectionAttrs)
      attrs);

in pkgs.writeText "qBittorrent.conf" (formatAttrset cfg.settings)
