{
  dotfiles,
  helpers,
  inputs,
  ...
}:
let
  wezterm = helpers.wrapPackage {
    name = "wezterm";
    # package = inputs.wezterm.packages.${settings.system.platform}.default;
    # package = (helpers.getPkgs inputs.nixpkgs-unstable).wezterm;
    package = (helpers.getPkgs inputs.nixpkgs-24_05).wezterm;
    extraFlags = "--config-file ${dotfiles.path}/wezterm/wezterm.lua";
    extraArgs = "--set XDG_CONFIG_HOME '${dotfiles.path}'";
  };
in
{
  environment.systemPackages = [ wezterm ];
}
