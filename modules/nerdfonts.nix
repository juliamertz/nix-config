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
    enable = mkEnableOption (mkDoc "Nerd fonts");
    enableUnfree = mkEnableOption (mkDoc ''
      Include unfree nerdfonts from private repository
    '');
  };

  config = lib.mkIf cfg.enable {
    fonts.packages =
      (with pkgs.nerd-fonts; [
        jetbrains-mono
      ])
      ++ lib.optionals cfg.enableUnfree (
        let
          revision = "5dd5da7823475972be33eaf2d8df0933896b67db";
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
