{
  pkgs,
  settings,
  ...
}: {
  imports = [./shared.nix];

  users.users.${settings.user.username} = {
    description = settings.user.fullName;
    inherit (settings.user) home;
  };

  environment.systemPackages = [
    pkgs.nh
  ];
}
