{ lib, inputs, dotfiles, helpers, settings, ... }:
let
  user = user.settings.username;
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
      rev = "50dcde62f933ef3da251db914eb71ad89a3566b0";
      sha256 = "sha256-I03hQWgCUiXL9v46mlkW9T2hjARoxIMZEgz7V0HHcts=";
    };
    hash = "";
    cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
      name = "${base.name}-vendor.tar.gz";
      src = base.src;
    });
  });

  # sops.secrets = helpers.ownedSecrets user [ "spotify_client_id" ];

  sops.secrets = {
    spotify_client_id = { owner = settings.user.username; };
  };

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

