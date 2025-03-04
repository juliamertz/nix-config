{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "alternate-twitch-player" = buildFirefoxXpiAddon {
      pname = "alternate-twitch-player";
      version = "2024.7.3";
      addonId = "twitch5@coolcmd";
      url = "https://addons.mozilla.org/firefox/downloads/file/4313555/twitch_5-2024.7.3.xpi";
      sha256 = "f04b583cc10caef8085102da3ffcee5f8f777511b88d5df824696645caade879";
      meta = with lib;
      {
        description = "Alternate player of live broadcasts for <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/05d29d585236bab4d25a715364ff0a5b5243556af4f39e4425fb82c9f8ca27a3/https%3A//www.twitch.tv/\" rel=\"nofollow\">Twitch.tv</a> website.";
        mozPermissions = [
          "storage"
          "cookies"
          "webRequest"
          "webRequestBlocking"
          "clipboardWrite"
          "*://*.twitch.tv/*"
          "*://*.twitchcdn.net/*"
          "*://*.ttvnw.net/*"
          "*://*.jtvnw.net/*"
          "*://*.live-video.net/*"
          "*://*.akamaized.net/*"
          "*://*.cloudfront.net/*"
          "https://www.twitch.tv/*"
          "https://m.twitch.tv/*"
        ];
        platforms = platforms.all;
      };
    };
    "swagger-ui" = buildFirefoxXpiAddon {
      pname = "swagger-ui";
      version = "1.0.6";
      addonId = "{5dc6ca4a-29bb-47ef-812f-e03dddafb354}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3425331/swagger_ui_ff-1.0.6.xpi";
      sha256 = "5680cd1243b6534501285ce775c65a392e3ac0c14702c42eb3da953b28202236";
      meta = with lib;
      {
        homepage = "https://github.com/sammy8806/firefox-swagger-ui";
        description = "Swagger-UI for Firefox";
        mozPermissions = [ "https://*/" "http://*/" "tabs" "clipboardWrite" ];
        platforms = platforms.all;
      };
    };
  }
