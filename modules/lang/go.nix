{ pkgs, helpers, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      go
      gopls
      gcc
    ]
    ++ lib.optionals helpers.isLinux [ libcap ];
}
