{
  pkgs,
  settings,
  config,
  ...
}:
let
  inherit (settings.system) platform;
  inherit (pkgs) lib;

  port = 42069;
  name = "lightspeed-dhl-adapter";
  group = "valnetten";

  bin = (builtins.getFlake "github:juliamertz/lightspeed-dhl-adapter").packages.${platform}.default;

in
{
  users.groups.${group}.gid = 6900;
  users.users.${group} = {
    inherit group;
    uid = 6900;
  };

  sops.templates."lightspeed-dhl.toml".owner = group;
  sops.templates."lightspeed-dhl.toml".content =
    let
      inherit (config.sops.placeholder.valnetten) dhl lightspeed;
    in
    # toml
    ''
      [DHL]
      AccountId = "${dhl.accountId}"
      UserId    = "${dhl.userId}"
      ApiKey = "${dhl.apiKey}"

      [Lightspeed]
      Cluster = "https://api.webshopapp.com/nl/"
      Key     = "${lightspeed.key}"
      Secret  = "${lightspeed.secret}"
      Frontend = "https://nettenshop.webshopapp.com"

      [CompanyInfo]
      Name         = "Nettenshop"
      Street       = "Rondven"
      City         = "Maarheeze"
      PostalCode   = "6026PX"
      CountryCode  = "NL"
      Number       = "41"
      Addition     = "A"
      Email        = "info@nettenshop.nl"
      PhoneNumber  = "+31402901155"
      PersonalNote = "Uw bestelling bij nettenshop.nl is met DHL onderweg! Via de bijgevoegde link kunt u uw pakket volgen. Mocht u vragen hebben, neem dan contact met ons op via de klantenservice. Met vriendelijke groet, Team Nettenshop.nl"

      [Options]
      DryRun      = false 
      Port        = ${port} 
      Environment = "production"
      Debug       = false
      PollingInterval = 1
    '';

  systemd.services.${name} = {
    description = "${name} service";

    serviceConfig = {
      Type = "simple";
      User = group;
      Group = group;

      ExecStart = "${lib.getExe bin} ${config.sops.templates."lightspeed-dhl.toml".path}";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.lightspeed-dhl-integration = {
      entryPoints = [ "http" ];
      rule = "Host(`juliamertz.dev`)";
      service = name;
    };
    services = {
      ${name}.loadBalancer.servers = [ { url = "http://localhost:${port}"; } ];
    };
  };

}
