{ pkgs, ... }: { environment.systemPackages = with pkgs; [ libcap go gcc ]; }
