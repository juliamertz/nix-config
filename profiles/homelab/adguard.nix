{ inputs, helpers, ... }:
let
  host = "0.0.0.0";
  port = 3003;
  package = (helpers.getPkgs inputs.nixpkgs-unstable).adguardhome;

  enabledFilters =
    list:
    map (url: {
      enabled = true;
      inherit url;
    }) list;
in
{
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  systemd.services.adguardhome = {
    serviceConfig = {
      User = "root";
      Group = "root";
    };
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    inherit port package host;

    settings = {
      dns = {
        upstream_dns = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };

      filtering = {
        rewrites = [
          {
            domain = "homelab.lan";
            answer = "192.168.0.100";
          }
          {
            domain = "workstation.lan";
            answer = "192.168.0.101";
          }
          {
            domain = "*.homelab.lan";
            answer = "192.168.0.100";
          }
          {
            domain = "router.lan";
            answer = "192.168.0.1";
          }
        ];

        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;

      };
      filters = enabledFilters [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_3_Spyware/filter.txt" # Tracking and spyware
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_17_TrackParam/filter.txt" # param tracking
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_4_Social/filter.txt" # Social media invase
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_14_Annoyances/filter.txt" # Annoyances
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_8_Dutch/filter.txt" # dutch filter
      ];
    };
  };

}
