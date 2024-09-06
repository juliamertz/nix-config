{
  pkgs,
  dotfiles,
  helpers,
  ...
}:
let
  fish = helpers.wrapPackage {
    name = "fish";
    package = pkgs.fish;
    extraArgs = "--set XDG_CONFIG_HOME '${dotfiles.path}'";
    dependencies = with pkgs; [
      bat
      jq
      zoxide
    ];
  };
in
{
  environment.systemPackages = [ fish ];
}
