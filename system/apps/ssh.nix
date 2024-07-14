{ pkgs, ... }:
let 
  script = ''
    #!/usr/bin/env bash
    API_KEY=$(cat /run/secrets/zerotier_api_key)
    NETWORK_ID=$(cat /run/secrets/zerotier_network_id)
    FLAKE_PATH=$HOME/nix
    REMOTES=$(sops -d $FLAKE_PATH/secrets/personal.yaml | yq .remotes)

    function call_api() {
      curl -s -H "Authorization: token $API_KEY" https://api.zerotier.com/api/v1$@
    }

    function zerotier_member() {
      members=$(call_api /network/$NETWORK_ID/member -X GET)
      authorized_members=$(echo $members | jq '.[] | select(.config.authorized==true)')
      echo $authorized_members | jq ". | select(.name==\"$1\")"
    }

    function get_user() {
      echo $REMOTES | jq ".$1.user"
    }

    if [[ "$1" == "tunnel" ]]; then
      member=$(zerotier_member $2)
      ip=$(echo $member | jq '.config.ipAssignments[0]' | xargs)
      user=$(get_user $2 | xargs)

      ssh $user@$ip
      exit 0
    fi

    user=$(get_user $1 | xargs)
    ip=$(echo $REMOTES | jq ".$1.host" | xargs)
    ssh $user@$ip
  '';
in {
  environment.systemPackages = [ (pkgs.writeShellScriptBin "remote" script) ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];
}
