# https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
{ pkgs }: 
args:
let 
  defaultValues = {
    extraFlags = "";
    extraArgs = "";
    extraCommands = "";
    dependencies = [];
  };

  cfg = defaultValues // args;
in
pkgs.symlinkJoin {
  name = cfg.name;
  paths = [ cfg.package ] ++ cfg.dependencies;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/${cfg.name} \
      --add-flags "${cfg.extraFlags}" ${cfg.extraArgs}

    ${cfg.extraCommands}
  '';
}
