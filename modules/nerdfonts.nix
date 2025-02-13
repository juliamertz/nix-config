{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nerdfonts;
in
{
  options.nerdfonts = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    enableUnfree = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages =
      (with pkgs.nerd-fonts; [
        jetbrains-mono
      ])
      ++ lib.optionals cfg.enableUnfree (
        let
          revision = "2e81dc4af958e4083a9cd1435cc35f87f468ca85";
          repo = "git+ssh://git@github.com/juliamertz/fonts.git?rev=${revision}";
          fonts = (builtins.getFlake repo).packages.${pkgs.system};
        in
        with fonts;
        [
          berkeley-mono
        ]
      );
  };
}
