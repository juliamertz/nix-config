{pkgs, ...}: let
  # latest pavucontrol version that is built with gtk-3.0 and allows for easy theming
  pinned = (
    import (builtins.fetchTarball {
      name = "nixpkgs-pavucontrol-5.0";
      url = "https://github.com/nixos/nixpkgs/archive/b60793b86201040d9dee019a05089a9150d08b5b.tar.gz";
      sha256 = "sha256:1g1j4fg5jmd92dxzjzrbb8f63qkwqxgr8z339cxjzz2pfg4zyliy";
    }) {system = pkgs.stdenv.hostPlatform.system;}
  );
in {
  environment.systemPackages = with pinned; [pavucontrol];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pipewire.wireplumber.extraConfig = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
    };
  };

  # services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
  #   "wireplumber.settings" = {
  #     "bluetooth.autoswitch-to-headset-profile" = false;
  #   };
  # };
}
