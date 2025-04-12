{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit
    (config.hardware.wheel.g920)
    enable
    vendorId
    productId
    ;

  id = "${vendorId}:${productId}";
in {
  options.hardware.wheel.g920 = with lib; {
    enable = mkEnableOption "Logitech G920 Racing wheel";
    vendorId = mkOption {
      type = types.str;
      default = "046d";
    };
    productId = mkOption {
      type = types.str;
      default = "c261";
    };
  };

  config = lib.mkIf enable {
    hardware.new-lg4ff.enable = true;

    services.udev = {
      packages = with pkgs; [oversteer];
      extraRules = lib.concatStringsSep ", " [
        "ATTR{idVendor}=='${vendorId}'"
        "ATTR{idProduct}=='${productId}'"
        ''RUN+="${pkgs.usb-modeswitch} -c '/etc/usb_modeswitch.d/${id}'"''
      ];
    };

    environment.etc."usb_modeswitch.d/${id}".text = ''
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
  };
}
