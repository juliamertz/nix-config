{ pkgs, lib, ... }: 
let 
  arkenfoxUserJS = builtins.fetchTarball https://github.com/arkenfox/user.js/archive/refs/tags/126.1.tar.gz;
in { 
  environment.systemPackages = with pkgs; [ firefox ];
  
}
