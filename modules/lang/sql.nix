{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    sqlite
    litecli
    nodePackages.sql-formatter
  ];
}
