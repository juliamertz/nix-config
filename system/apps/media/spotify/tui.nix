{ lib, inputs, dotfiles, helpers, settings, ... }:
let
  pkgs = inputs.nixpkgs-unstable.legacyPackages.${settings.system.platform};
  base = pkgs.spotify-player.override {
    withAudioBackend = "alsa";
    withSixel = false;
    withNotify = false;
    withLyrics = false;
  };

  overlay = base.overrideAttrs (old: {
    name = "spotify_player";
    src = pkgs.fetchFromGitHub {
      owner = "juliamertz";
      repo = "spotify-player";
      rev = "d68c80cf7d6711e611ba3e58e83679fbd44601ac";
      sha256 = "sha256-NC2WfwFiJGFqojCQJ9WPblyDU2K+pF7ahkLl/gQ8x7Y=";
    };
    # cargoHash = "sha256-R9N/+29YNWlNnl2+q/MMUZ/MbfFL538z5DLBZxDeaUM=";
    # cargoHash = "";
    hash = "";
    cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
      name = "${base.name}-vendor.tar.gz";
      src = base.src;
      # outputHash = base.cargoHash;
    });
  });

  wrapped = helpers.wrapPackage {
    package = overlay;
    name = "spotify_player";
    extraFlags = "--config-folder ${dotfiles.path}/spotify-player";
    postWrap = # sh
      ''
        ln -sf $out/bin/spotify_player $out/bin/spt
      '';
  };
in { environment.systemPackages = [ wrapped ]; }

