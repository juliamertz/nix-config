{
  pkgs,
  helpers,
  config,
  ...
}:
let
  inherit (pkgs) callPackage;
  inherit (config) sops;

  # FIX: Can't get TLS working with cloudflare 

  # package =
  #   let
  #     # Modified package that can be built with custom plugins
  #     repo = "jpds/nixpkgs";
  #     rev = "a33b02fa9d664f31dadc8a874eb1a5dbaa9f4ecf";
  #     source = builtins.fetchurl {
  #       url = "https://raw.githubusercontent.com/${repo}/${rev}/pkgs/servers/caddy/default.nix";
  #       sha256 = "sha256:1x1g6qyhmclz2jyc5nmfjsri3xx4pw5rd15n2xjkxlgdcvywcv5f";
  #     };
  #     # This will change everytime plugins are modified
  #     vendorHash = "sha256-YRsPu+rTu9HEQQlj4dK2BH8DNGHo//VL5zhoU0hz7DI=";
  #     externalPlugins = [
  #       {
  #         name = "caddy-dns/cloudflare";
  #         repo = "github.com/caddy-dns/cloudflare";
  #         version = "89f16b99c18ef49c8bb470a82f895bce01cbaece";
  #       }
  #     ];
  #   in
  #   callPackage source { inherit vendorHash externalPlugins; };

  #   tls = ''
  #     tls {
  #         dns cloudflare {env.CF_API_TOKEN}
  #         resolvers 1.1.1.1
  #     }
  #   '';

in
{
  sops.secrets = helpers.ownedSecrets "caddy" [ "cloudflare_api_token" ];
  sops.templates."caddy.env".content = ''
    CF_API_TOKEN = ${sops.placeholder.cloudflare_api_token}
  '';

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = [ sops.templates."caddy.env".path ];
  };

  services.caddy = {
    enable = true;

    virtualHosts = {
      "juliamertz.dev".extraConfig = ''
        encode gzip
        file_server
        root * ${callPackage ./services/blog.nix { }}
      '';

      "watch.juliamertz.dev".extraConfig = ''
        reverse_proxy http://10.100.0.2:8096
      '';

      # basicauth / {
      #   Julia $2a$14$pPXridH6UTUpvfYjVF4L3.S.29qvBD6RYKC8hWnhx4K0F0mZkRsgC
      # }
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
