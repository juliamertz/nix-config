{
  config,
  inputs,
  helpers,
  ...
}: let
  host = "0.0.0.0";
  port = 3003;
  package = (helpers.getPkgs inputs.nixpkgs-unstable).adguardhome;

  enabledFilters = list:
    map (url: {
      enabled = true;
      inherit url;
    })
    list;
in {
  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  networking.nameservers = [
    "94.140.14.140"
    "94.140.14.141"
  ];

  # TODO: get this working without root privilleges
  systemd.services.adguardhome = {
    serviceConfig = {
      User = "root";
      Group = "root";
    };
  };

  reverse-proxy.services.adguardhome = {
    subdomain = "adguard";
    port = config.services.adguardhome.port;
    theme = true;
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    inherit port package host;

    settings = {
      dns = {
        bind_hosts = ["192.168.0.100"];
        upstream_mode = "parallel";
        upstream_dns = [
          # Adguard DNS non-filtering
          "94.140.14.140"
          "94.140.14.141"

          # cloudflare
          "1.1.1.1"
          "1.0.0.1"

          # dns0.eu
          "193.110.81.0"
          "185.253.5.0"
        ];
      };

      filtering = {
        safe_search.enabled = false;
        rewrites = [
          {
            domain = "homelab.lan";
            answer = "192.168.0.100";
          }
          {
            domain = "*.homelab.lan";
            answer = "192.168.0.100";
          }
          {
            domain = "workstation.lan";
            answer = "192.168.0.101";
          }
          {
            domain = "router.lan";
            answer = "192.168.0.1";
          }
        ];

        blocked_services.ids = [
          # western spyware
          "4chan"
          "amazon"
          "valorant"
          "vimeo"
          "skype"
          "facebook"

          # misc spyware
          "viber"
          "nintendo"
          "samsung_tv_plus"
          "vk"

          # chinese spyware
          "tiktok"
          "weibo"
          "bilibili"
          "shein"
          "aliexpress"
          "temu"
          "xiaohongshu"
          "zhihu"
          "wechat"
          "wizz"
        ];

        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
      };
      filters = enabledFilters [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_3_Spyware/filter.txt" # Tracking and spyware
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_17_TrackParam/filter.txt" # param tracking
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_4_Social/filter.txt" # Social media invase
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_14_Annoyances/filter.txt" # Annoyances
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_8_Dutch/filter.txt" # dutch filter
        "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/pro.mini.txt"
      ];
    };
  };
}
