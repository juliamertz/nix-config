{
  writeShellScriptBin,
  wol,
  lib,
}:
writeShellScriptBin "wake" # sh
  ''
    case $1 in
      "workstation")       
        IP=192.168.0.101
        MAC_ADDRESS=04:7c:16:eb:df:9b
        ;;
      *)              
        echo No such device
        exit 1
    esac

    ${lib.getExe wol} --verbose --ipaddr=$IP $MAC_ADDRESS
  ''
