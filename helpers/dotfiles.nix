{ local, package, ... }:
{
  path = if local.enable then local.path else builtins.toString package;
}
