# https://nixos.wiki/wiki/Nix_Cookbook#Wrapping_packages
{ symlinkJoin, makeWrapper, lib }: 
args:
let 
  defaultValues = {
    extraFlags = "";
    extraArgs = "";
    dependencies = [];
    postWrap = "";
    preWrap = "";
  };

  cfg = defaultValues // args;

  join = value:
    if builtins.isList value then
      lib.concatStringsSep " " value
    else
      value;
in
symlinkJoin {
  name = cfg.name;
  paths = [ cfg.package ] ++ cfg.dependencies;
  buildInputs = [ makeWrapper ];
  postBuild = ''
    ${cfg.preWrap}
    wrapProgram $out/bin/${cfg.name} \
      --add-flags "${join cfg.extraFlags}" ${join cfg.extraArgs}
    ${cfg.postWrap}
  '';
}
