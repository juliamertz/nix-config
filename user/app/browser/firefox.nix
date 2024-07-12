{ pkgs, userSettings, ... }:
{
  home.packages = [ pkgs.firefox ];

  programs.firefox.enable = true;

  # home.file.".mozilla/defaults/pref/user.js".text /* javascript */ = ''
  #   /* Personal preferences  */
  #   user_pref("full-screen-api.warning.timeout", 0);
  #   user_pref("full-screen-api.warning.delay", 0);
  #   // This allows tabs to go fullscreen while the browser stays in windowed mode
  #   user_pref("full-screen-api.ignore-widgets", true);
  #   // user_pref("security.fileuri.strict_origin_policy", false);
  #   user_pref("browser.urlbar.trimURLs", false);
  #   user_pref("browser.aboutConfig.showWarning", false);
  #   user_pref("browser.download.dir", "/home/joris/downloads");
  #   user_pref("browser.translations.automaticallyPopup", false);
  #   user_pref("accessibility.typeaheadfind", true);
  #   user_pref("browser.startup.page", 0);
  #   user_pref("browser.startup.homepage", "about:blank");
  #   user_pref("browser.newtabpage.enabled", false);
  #
  #   /* Browser hardening */
  #   user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
  #   user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
  #   user_pref("privacy.fingerprintingProtection", true);
  #   user_pref("browser.formfill.enable", false);
  #   user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
  #   user_pref("browser.newtabpage.activity-stream.showSponsored", false);
  #   user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
  #   user_pref("browser.newtabpage.activity-stream.default.sites", "");
  #   user_pref("geo.provider.ms-windows-location", false);
  #   user_pref("geo.provider.use_corelocation", false);
  #   user_pref("geo.provider.use_gpsd", false);
  #   user_pref("geo.provider.use_geoclue", false);
  #   user_pref("extensions.getAddons.showPane", false);
  #   user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
  #   user_pref("browser.discovery.enabled", false);
  #   user_pref("browser.shopping.experience2023.enabled", false);
  #   user_pref("datareporting.policy.dataSubmissionEnabled", false);
  #   user_pref("datareporting.healthreport.uploadEnabled", false);
  #   user_pref("toolkit.telemetry.unified", false);
  #   user_pref("toolkit.telemetry.enabled", false);
  #   user_pref("toolkit.telemetry.server", "data:,");
  #   user_pref("toolkit.telemetry.archive.enabled", false);
  #   user_pref("toolkit.telemetry.newProfilePing.enabled", false);
  #   user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
  #   user_pref("toolkit.telemetry.updatePing.enabled", false);
  #   user_pref("toolkit.telemetry.bhrPing.enabled", false);
  #   user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
  #   user_pref("toolkit.telemetry.coverage.opt-out", true);
  #   user_pref("toolkit.coverage.opt-out", true);
  #   user_pref("toolkit.coverage.endpoint.base", "");
  #   user_pref("browser.ping-centre.telemetry", false);
  #   user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
  #   user_pref("browser.newtabpage.activity-stream.telemetry", false);
  #   user_pref("app.shield.optoutstudies.enabled", false);
  #   user_pref("app.normandy.enabled", false);
  #   user_pref("app.normandy.api_url", "");
  #   user_pref("network.proxy.socks_remote_dns", true);
  #   user_pref("network.file.disable_unc_paths", true);
  #   user_pref("network.gio.supported-protocols", "");
  #   user_pref("signon.autofillForms", false);
  #   user_pref("signon.formlessCapture.enabled", false);
  #   user_pref("network.auth.subresource-http-auth-allow", 1);
  #   user_pref("security.ssl.require_safe_negotiation", true);
  #   user_pref("security.tls.enable_0rtt_data", false);
  # '';
}
