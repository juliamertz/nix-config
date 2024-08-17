{ lib, inputs, dotfiles, helpers, settings, ... }:
let
  user = settings.user.username;
  pkgs = inputs.nixpkgs-unstable.legacyPackages.${settings.system.platform};

  featureFlags = {
    withAudioBackend = "alsa";
    withSixel = false;
    withNotify = false;
    withLyrics = false;
  };
  base = pkgs.spotify-player.override featureFlags;
  overlay = base.overrideAttrs (old:
    {
      name = base.name;
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
    } // featureFlags);

  wrapped = helpers.wrapPackage {
    package = overlay;
    name = "spotify_player";
    extraFlags = "--config-folder ${dotfiles.path}/spotify-player";
    postWrap = # sh
      ''
        ln -sf $out/bin/spotify_player $out/bin/spt
      '';
  };
in {
  sops.secrets = helpers.ownedSecrets user [ "spotify_client_id" ];

  environment.systemPackages = [ wrapped ];
}

