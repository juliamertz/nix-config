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
        rev = "94e243300a10723d86c01a6798c946306debb3c3";
        sha256 = "sha256-BgoIdGuyAJSnhm/HwcvKXG9J65lrmtlt0kVsdM1z//4=";
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

