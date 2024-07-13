{ pkgs, config, lib, settings, ... }:
let
  wrap = pkgs.callPackage ./wrap.nix { };
  wineUnstable = pkgs.wineWow64Packages.full.override (old: {
    wineRelease = "unstable";
  });

  wine-wrapped = wrap { 
    wine = wineUnstable.overrideAttrs (oldAttrs: rec {
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.winehq.org";
        owner = "elementalwarrior";
        repo = "wine";
        rev = "c12ed1469948f764817fa17efd2299533cf3fe1c";
        hash = "sha256-eMN4SN8980yteYODN2DQIVNEJMsGQE8OIdPs/7DbvqQ=";
      };
      version = "8.14";
    });
  };

  winetricks = pkgs.winetricks.overrideAttrs (old: rec {
    src = pkgs.fetchFromGitHub {
      owner = "Winetricks";
      repo = "winetricks";
      rev = "20240105";
      hash = "sha256-YTEgb19aoM54KK8/IjrspoChzVnWAEItDlTxpfpS52w=";
    };
    version = src.rev;
  });
in {
  home.packages = [ winetricks ];

  nixpkgs.config.packageOverrides = pkgs: {
    wineElementalWarrior = wine-wrapped;
  };
}

