{ inputs, settings, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  homebrew.enable = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = settings.user.username;

    mutableTaps = false;
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };
}
