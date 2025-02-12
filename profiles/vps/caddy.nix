{
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;

    virtualHosts =
      let
        domain = "juliamertz.dev";
      in
      {
        ${domain}.extraConfig = ''
          encode gzip
          file_server
          root * ${pkgs.callPackage ./services/blog.nix { }}
        '';

        "nettenshop.${domain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:42069
        '';

        "watch.${domain}".extraConfig = ''
          reverse_proxy http://10.100.0.2:8096
        '';
      };
  };
}
