{ writeShellScriptBin, ... }:
{
  fd =
    writeShellScriptBin "fd" # bash
      ''
        find ''${@:-.} -type d | fzf
      '';
  ff =
    writeShellScriptBin "ff" # bash
      ''
        find ''${@:-.} -type f | fzf
      '';
}
