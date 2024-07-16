{ pkgs, inputs, ... }:
let
  g920 = {
    vendorId = "046d";
    # productId = "c261";
    productId = "c261";
    id = g920.vendorId + ":" + g920.productId;
  };
in {
  imports = [
    ../../system/apps/sunshine.nix
    ../../system/apps/game-launchers.nix
  ];

  hardware.new-lg4ff.enable = true;
  services.udev.packages = with pkgs; [ oversteer ];
  services.udev.extraRules = ''
    ATTR{idVendor}=="${g920.vendorId}", ATTR{idProduct}=="${g920.productId}", RUN+="${pkgs.usb-modeswitch} -c '/etc/usb_modeswitch.d/${g920.id}'"
  '';

  environment.etc."usb_modeswitch.d/${g920.id}".text = /* ini */ ''
    # Logitech G920 Racing Wheel
    DefaultVendor=${g920.vendorId}
    DefaultProduct=${g920.productId}
    MessageEndpoint=01
    ResponseEndpoint=01
    TargetClass=0x03
    MessageContent="0f00010142"
'';

  environment.systemPackages = with pkgs; [
    wine
    winetricks
    protontricks
    usbutils
    usb-modeswitch
    oversteer
    mangohud
    discord
    inputs.suyu.packages.x86_64-linux.suyu
  ];
}
