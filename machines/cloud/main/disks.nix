{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              label = "boot";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              label = "nixos";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
# # Example to create a bios compatible gpt partition
# { lib, ... }:
# {
#   disko.devices = {
#
#     disk.main = {
#       device = lib.mkDefault "/dev/sda";
#       type = "disk";
#
#       content = {
#         type = "gpt";
#         partitions = {
#           boot = {
#             name = "boot";
#             size = "1M";
#             type = "EF02";
#           };
#           esp = {
#             name = "ESP";
#             size = "500M";
#             type = "EF00";
#             content = {
#               type = "filesystem";
#               format = "vfat";
#               mountpoint = "/boot";
#             };
#           };
#           root = {
#             name = "root";
#             size = "100%";
#             content = {
#               type = "lvm_pv";
#               vg = "pool";
#             };
#           };
#         };
#       };
#     };
#
#     lvm_vg = {
#       pool = {
#         type = "lvm_vg";
#         lvs = {
#           root = {
#             size = "100%FREE";
#             content = {
#               type = "filesystem";
#               format = "ext4";
#               mountpoint = "/";
#               mountOptions = [
#                 "defaults"
#               ];
#             };
#           };
#         };
#       };
#     };
#
#   };
# }

