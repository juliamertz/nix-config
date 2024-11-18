{
  pkgs,
  lib,
  ...
}:
let
  vendorId = "046d";
  productId = "c261";
  id = "${vendorId}:${productId}";
in
{
  hardware.new-lg4ff.enable = true;
  services.udev.packages = with pkgs; [ oversteer ];
  # services.udev.extraRules = ''
  #   ATTR{idVendor}=="${vendorId}", ATTR{idProduct}=="${productId}", RUN+="${pkgs.usb-modeswitch} -c '/etc/usb_modeswitch.d/${id}'"
  # '';

  services.udev.extraRules = lib.concatStringsSep ", " [
    "ATTR{idVendor}=='${vendorId}'"
    "ATTR{idProduct}=='${productId}'"
    ''RUN+="${pkgs.usb-modeswitch} -c '/etc/usb_modeswitch.d/${id}'"''
  ];

  environment.etc."usb_modeswitch.d/${id}".text = # ini
    ''
      DefaultVendor=${vendorId}
      DefaultProduct=${productId}
      MessageEndpoint=01
      ResponseEndpoint=01
      TargetClass=0x03
      MessageContent="0f00010142"
    '';

  environment.systemPackages = with pkgs; [
    usbutils
    usb-modeswitch
    oversteer
  ];
}
