final: prev:
let
  fetchTheme =
    opts:
    prev.stdenvNoCC.mkDerivation {
      inherit (opts) src name;
      installPhase = "cp -r $src $out";
    };
in
{
  home-assistant-custom-components = prev.home-assistant-custom-components // {
    # actively maintained fork of localtuya
    localtuya = prev.home-assistant-custom-components.localtuya.overrideAttrs (old: {
      owner = "xZetsubou";
      src = prev.fetchFromGitHub {
        owner = "xZetsubou";
        repo = "hass-localtuya";
        rev = "1bfa9aa21ef4c672f9b3be19332f0f8f633db267";
        hash = "sha256-MLegZZ2q1/h2T+Edl8QtUPlv0rJYLaugtoVt/AZ6+QM=";
      };
    });
  };

  home-assistant-custom-themes = {
    rose-pine = fetchTheme {
      name = "rose-pine";
      src = prev.fetchFromGitHub {
        owner = "juliamertz";
        repo = "homeassistant-rosepine-theme";
        rev = "6ff4de154a3456ae1bcf939a6495c0ba0c41fab1";
        hash = "sha256-uZsPu6BS/7eyUQZBqc0K+WI+VnKsdfCrY547CcR4zLI=";
      };
    };
  };
}
