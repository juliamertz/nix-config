{
  inputs,
  pkgs,
  lib,
  helpers,
  ...
}: let
  firefoxAddons = inputs.nur.packages.${pkgs.system}.firefoxAddons;
in
  {
    programs.librewolf = {
      enable = true;
      profiles.julia = {
        isDefault = true;

        extensions.packages = with firefoxAddons; [
          vimium
          darkreader
          proton-pass
          alternate-twitch-player
          return-youtube-dislikes
          swagger-ui
          augmented-steam
          protondb-for-steam
          firefox-color

          stylus # userstyles
          greasemonkey # userscripts

          # adblocking
          ublock-origin
          sponsorblock
          i-dont-care-about-cookies
          disable-javascript

          # privacy
          privacy-badger
          decentraleyes
          leechblock-ng
        ];

        settings = {
          "privacy.clearOnShutdown.cache" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown_v2.cache" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;

          "browser.newtabpage.enabled" = true;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.startup.page" = 3;

          "privacy.resistFingerprinting" = false;
          "privacy.fingerprintingProtection" = true;
          "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";

          # automatically enable all extensions
          "extensions.autoDisableScopes" = 0;

          # dont maximize window when website goes fullscreen
          "full-screen-api.ignore-widgets" = true;
          "full-screen-api.warning.timeout" = 0;
          "full-screen-api.warning.delay" = 0;

          # "identity.fxaccounts.enabled" = false; # Disable fx accounts
          # Disable "save password" prompt
          "signon.rememberSignons" = false;
          # disable translation popups
          "browser.translations.enable" = false;

          # Harden
          "privacy.trackingprotection.enabled" = true;
          "dom.security.https_only_mode" = true;

          # Disable annoying first-run stuff
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.feeds.showFirstRunUI" = false;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          "browser.urlbar.quickactions.enabled" = false;
          "browser.urlbar.quickactions.showPrefs" = false;
          "browser.urlbar.shortcuts.quickactions" = false;
          "browser.urlbar.suggest.quickactions" = false;
        };

        search.engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          "Docs.rs" = {
            urls = [
              {
                template = "https://docs.rs/releases/search";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            definedAliases = ["@docsrs"];
          };

          "MyNixOS" = {
            urls = [
              {
                template = "https://mynixos.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            definedAliases = ["@mynixos"];
          };
        };

        search.force = true;
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  }
  // (lib.optionalAttrs helpers.isLinux {
    stylix.targets.librewolf.profileNames = [
      "julia"
    ];
  })
