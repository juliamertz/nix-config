{
  pkgs,
  settings,
  config,
  helpers,
  ...
}:
let
  inherit (settings.system) platform;
  inherit (pkgs) lib;
  toStr = builtins.toString;

  port = 42069;
  name = "lightspeed-dhl-adapter";

  user = "valnetten";
  group = "valnetten";

  revision = "9af6be0583bb2ed7bd2717fa09ac786fb40703af";
  repo = "lightspeed-dhl-adapter";
  bin =
    (builtins.getFlake "github:juliamertz/${repo}/${revision}?dir=nix")
    .packages.${platform}.default;

in
{
  systemd.services.${name} = {
    description = "${name} service";

    serviceConfig = {
      Type = "simple";
      User = user;
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
      ${name}.loadBalancer.servers = [ { url = "http://localhost:${toStr port}"; } ];
    };
  };

  sops.secrets = helpers.ownedSecrets group [
    "dhl_accountId"
    "dhl_userId"
    "dhl_apiKey"
    "lightspeed_key"
    "lightspeed_secret"
  ];

  sops.templates."lightspeed-dhl.toml" = {
    owner = group;
    content =
      let
        inherit (config.sops.placeholder)
          dhl_accountId
          dhl_userId
          dhl_apiKey
          lightspeed_key
          lightspeed_secret
          ;
      in
      # toml
      ''
        [DHL]
        AccountId = "${dhl_accountId}"
        UserId    = "${dhl_userId}"
        ApiKey = "${dhl_apiKey}"

        [Lightspeed]
        Cluster = "https://api.webshopapp.com/nl/"
        Key     = "${lightspeed_key}"
        Secret  = "${lightspeed_secret}"
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
        Port        = ${toStr port} 
        Environment = "production"
        Debug       = false
        PollingInterval = 1
      '';
  };

  users.groups.${group}.gid = 6900;
  users.users.${user} = {
    inherit group;
    isNormalUser = true;
    uid = 6900;
  };

}
