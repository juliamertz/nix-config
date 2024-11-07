{
  local,
  package,
  platform,
  ...
}:
{
  path = if local.enable then local.path else builtins.toString package;
  pkgs = package.packages.${platform};
}
