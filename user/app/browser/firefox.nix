{ pkgs, inputs, settings, ... }:
let
  user = settings.user.username;
in {
  programs.firefox = {
    enable = true;
    # profiles.${user} = {

      # search.engines = {
      #   "Nix Packages" = {
      #     urls = [{
      #       template = "https://search.nixos.org/packages";
      #       params = [
      #         { name = "type"; value = "packages"; }
      #         { name = "query"; value = "{searchTerms}"; }
      #       ];
      #     }];
      #
      #     icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #     definedAliases = [ "@np" ];
      #   };
      # };
      # search.force = true;

      # bookmarks = [
      #   {
      #     name = "wikipedia";
      #     tags = [ "wiki" ];
      #     keyword = "wiki";
      #     url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
      #   }
      # ];

      # extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
      #   ublock-origin
      #   sponsorblock
      #   darkreader
      # ];

#       settings = {
#         "full-screen-api.warning.timeout" = 0;
#         "full-screen-api.warning.delay" = 0;
#         "full-screen-api.ignore-widgets" = true;
#         "browser.urlbar.trimURLs" = false;
#         "browser.aboutConfig.showWarning" = false;
#         "browser.download.dir" = "/home/joris/downloads";
#         "browser.translations.automaticallyPopup" = false;
#         "accessibility.typeaheadfind" = true;
#         "browser.startup.page" = 0;
#         "browser.startup.homepage" = "about:blank";
#         "browser.newtabpage.enabled" = false;
#         "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
#         "browser.urlbar.suggest.quicksuggest.sponsored" = false;
#         "privacy.fingerprintingProtection" = true;
#         "browser.formfill.enable" = false;
#         "browser.privatebrowsing.forceMediaMemoryCache" = true;
#         "browser.newtabpage.activity-stream.showSponsored" = false;
#         "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
#         "browser.newtabpage.activity-stream.default.sites" = "";
#         "geo.provider.ms-windows-location" = false;
#         "geo.provider.use_corelocation" = false;
#         "geo.provider.use_gpsd" = false;
#         "geo.provider.use_geoclue" = false;
#         "extensions.getAddons.showPane" = false;
#         "extensions.htmlaboutaddons.recommendations.enabled" = false;
#         "browser.discovery.enabled" = false;
#         "browser.shopping.experience2023.enabled" = false;
#         "datareporting.policy.dataSubmissionEnabled" = false;
#         "datareporting.healthreport.uploadEnabled" = false;
#         "toolkit.telemetry.unified" = false;
#         "toolkit.telemetry.enabled" = false;
#         "toolkit.telemetry.server" = "data:,";
#         "toolkit.telemetry.archive.enabled" = false;
#         "toolkit.telemetry.newProfilePing.enabled" = false;
#         "toolkit.telemetry.shutdownPingSender.enabled" = false;
#         "toolkit.telemetry.updatePing.enabled" = false;
#         "toolkit.telemetry.bhrPing.enabled" = false;
#         "toolkit.telemetry.firstShutdownPing.enabled" = false;
#         "toolkit.telemetry.coverage.opt-out" = true;
#         "toolkit.coverage.opt-out" = true;
#         "toolkit.coverage.endpoint.base" = "";
#         "browser.ping-centre.telemetry" = false;
#         "browser.newtabpage.activity-stream.feeds.telemetry" = false;
#         "browser.newtabpage.activity-stream.telemetry" = false;
#         "app.shield.optoutstudies.enabled" = false;
#         "app.normandy.enabled" = false;
#         "app.normandy.api_url" = "";
#         "network.proxy.socks_remote_dns" = true;
#         "network.file.disable_unc_paths" = true;
#         "network.gio.supported-protocols" = "";
#         "signon.autofillForms" = false;
#         "signon.formlessCapture.enabled" = false;
#         "network.auth.subresource-http-auth-allow" = 1;
#         "security.ssl.require_safe_negotiation" = true;
#         "security.tls.enable_0rtt_data" = false;
#         "dom.security.https_only_mode" = true;
#         "browser.download.panel.shown" = true;
#       };
    # };
  };
}

