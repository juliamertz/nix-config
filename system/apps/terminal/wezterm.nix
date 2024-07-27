{ dotfiles, helpers, inputs, settings, ... }:
let
  wezterm = helpers.wrapPackage {
    name = "wezterm";
    package = inputs.wezterm.packages.${settings.system.platform}.default;
    extraFlags = "--config-file ${dotfiles.path}/wezterm/wezterm.lua";
    extraArgs =  "--set XDG_CONFIG_HOME '${dotfiles.path}'";
  };
in
{
  environment.systemPackages = [ wezterm ];
}

