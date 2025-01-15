{ helpers, inputs, ... }:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
  # unstable build of nil_ls with support for pipe operators
  nil_ls =
    let
      repo = "oxalica/nil";
      rev = "2e24c9834e3bb5aa2a3701d3713b43a6fb106362";
    in
    (builtins.getFlake "github:${repo}/${rev}").packages.${pkgs.system}.default;
in
{
  environment.systemPackages =
    with pkgs;
    [
      nixfmt-rfc-style
      deadnix
      statix
    ]
    ++ [ nil_ls ];
}
