_:
let
  script = # sh
    ''
      find /games/SteamLibrary/steamapps/ -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; |\
      column -t -s '|' | sort -k 2
    '';
in
{
  environment.systemPackages = [ script ];
}
