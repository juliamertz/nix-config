{ pkgs, ... }:
let
  token = "$(cat /run/secrets/home_assistant_token)";
  base_url= "$(cat /run/secrets/home_assistant_ip)";
  
  cycleScene = /*bash*/ ''
    #!${pkgs.bash}
    if [ ! $1 == "next" ] && [ ! $1 == "previous" ]; then
      echo "Invalid arguments '$@'. Usage: 'cycle-scene <next|previous>'"
      exit 1
    fi

    run() {
      curl -X POST --silent \
          -H "Authorization: Bearer ${token}" \
          -H "Content-Type: application/json" \
          -d '{"entity_id": "input_select.active_scene"}' ${base_url}/api/services/input_select/select_$1 > /dev/null

      curl -X POST --silent \
          -H "Authorization: Bearer ${token}" \
          -H "Content-Type: application/json" \
          -d '{"entity_id": "script.apply_cycle_scene"}' ${base_url}/api/services/script/turn_on > /dev/null
    }

    run $1 &
  '';

  dimmer = /*bash*/''
    #!${pkgs.bash}
    if [[ $1 =~ ^[0-9]+$ ]]; then
      if [ $1 -ge 0 ] && [ $1 -le 100 ]; then
        curl -X POST --silent \
          -H "Authorization: Bearer ${token}" \
          -H "Content-Type: application/json" \
          -d "{\"entity_id\": \"light.all\", \"brightness_pct\": $1 }" \
          ${base_url}/api/services/light/turn_on > /dev/null &
          exit 0 
      else
        echo "Invalid argument: Step size should be between 0 and 100"
        exit 1
      fi
    elif [ "$1" = "up" ]; then
      step=20
    elif [ "$1" = "down" ]; then
      step=-20
    else 
      echo "Invalid argument '$@' Usage: 'ha-dimmer <up|down|0-100>"
      exit 1
    fi 

    curl -X POST --silent \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json" \
        -d "{\"entity_id\": \"light.all\", \"brightness_step_pct\": $step }" \
        ${base_url}/api/services/light/turn_on  > /dev/null &
  '';
in {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "ha-scene" cycleScene)
    (pkgs.writeShellScriptBin "ha-dimmer" dimmer)
  ];
}
