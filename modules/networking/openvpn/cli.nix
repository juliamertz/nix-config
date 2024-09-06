{ pkgs, config, ... }:
let
  cfg = config.openvpn.proton;
  script = # sh
    ''
        #!/usr/bin/env bash

        argv=''${@}
        subcommand=''${1}

        get_services() {
          systemctl list-unit-files --type=service --all | grep 'openvpn-.*-protonvpn.service' | awk '{print $1}'
        }

        get_active_services() {
          services=$(systemctl list-units --type=service --all | grep 'openvpn-.*-protonvpn.service' | awk '{print $1}')
          amount=$(echo "$services" | wc -w)

          if [ $amount -gt 1 ]; then
            echo ERROR: More than one vpn active
            echo TODO: implement select default with nix option and disable the rest
            exit 1
          else
            echo $services
          fi
        }

        active_services=$(get_active_services)

        service_is_active() {
          for service in $active_services; do
            if [[ $1 == $service ]]; then
              echo true
              return 0
            fi
          done

          echo false
        }

      i=0
      for service in $services; do
        i=$((i + 1))
      done
        stop_all_services() {
          for service in $active_services; do
            systemctl stop $service
          done

          # assertions
          active_services=$(get_active_services)
          for service in $(get_services); do
            is_active=$(service_is_active $service)
            if [[ $is_active == true ]]; then
              echo ERROR: Failed to stop service $service.
              exit 1
            fi
          done
        }

        if [[ $subcommand == "status" ]]; then
          if [ -z "$active_services" ]; then
            echo Connection dead
          else
            service=''${active_services[0]}
            sudo systemctl status $service
          fi
          exit 0

        elif [[ $subcommand == "disconnect" ]]; then
          stop_all_services

          exit 0

        elif [[ $subcommand == "connect" ]]; then
          profile=$2

          if [ -z $profile ]; then
            profile=${cfg.profile};
          fi

          if [ ! -z $active_services ]; then
            stop_all_services
          fi

          echo Starting $profile
          sudo systemctl start openvpn-$profile-protonvpn.service
          exit 0

        elif [[ $subcommand == "list" ]]; then
          get_services 
          exit 0
        fi

        echo $subcommand
    '';
in
{
  config = {
    environment.systemPackages = [ (pkgs.writeShellScriptBin "vpn" script) ];
  };
}
