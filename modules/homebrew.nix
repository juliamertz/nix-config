{
  pkgs,
  inputs,
  settings,
  ...
}: let
  crossToolchains = pkgs.fetchFromGitHub {
    owner = "messense";
    repo = "homebrew-macos-cross-toolchains";
    rev = "2a0a4036993160f555a3df86a53a91a89a2701ac";
    hash = "sha256-tNLvlVXHze5etN2K+p9OScm8v8zPWaTmSPrxARdQMRc=";
  };
in {
  imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];
  homebrew.enable = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = settings.user.username;

    mutableTaps = false;
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "messense/homebrew-macos-cross-toolchains" = crossToolchains;
    };
  };
}
