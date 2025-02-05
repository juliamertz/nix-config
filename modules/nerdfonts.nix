{ pkgs, inputs, ... }:
let 
  unfree = inputs.fonts.packages.${pkgs.system};
in
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    unfree.berkeley-mono
  ];
}
