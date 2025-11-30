{ pkgs, pkgsUnstable, ... }:
let
  mkFirefoxAddons =
    addons:
    let
      mkAddon =
        {
          id,
          name,
          private ? false,
          extraConfig ? { },
        }:
        {
          "${id}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
            installation_mode = "force_installed";
            allowed_in_private_browsing = private;
          }
          // extraConfig;
        };
    in
    builtins.foldl' (acc: addon: acc // mkAddon addon) { } addons;
in
{
  programs.firefox = {
    package = pkgsUnstable.firefox;
    enable = true;
    policies = {
      Homepage = {
        URL = "http://start.cfv3.org";
      };
      Preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "layers.acceleration.force-enabled" = true;
      };
      PromptForDownloadLocation = true;
      SearchEngines = {
        Add = [
          {
            Description = "DuckDuckGo";
            IconURL = "https://duckduckgo.com/favicon.ico";
            Method = "GET";
            Name = "DuckDuckGo";
            SuggestURLTemplate = "https://duckduckgo.com/ac/?q={searchTerms}";
            URLTemplate = "https://duckduckgo.com/?q={searchTerms}";
          }
        ];
        Default = "DuckDuckGo";
        DefaultPrivate = "DuckDuckGo";
        Remove = [
          "Bing"
          "eBay"
          "Google"
        ];
      };

      ExtensionSettings = mkFirefoxAddons [
        {
          name = "ublock-origin";
          id = "uBlock0@raymondhill.net";
          private = true;
        }
        {
          name = "bitwarden-password-manager";
          id = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
          private = true;
        }
        {
          name = "darkreader";
          id = "addon@darkreader.org";
        }
        {
          name = "auto-tab-discard";
          id = "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}";
        }
        {
          name = "sponsorblock";
          id = "sponsorBlocker@ajay.app";
        }
        {
          name = "tweaks-for-youtube";
          id = "{84c8edb0-65ca-43a5-bc53-0e80f41486e1}";
        }
        {
          name = "forest-stay-focused-be-present";
          id = "@forest-firefox-addon";
        }
        {
          name = "return-youtube-dislikes";
          id = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
        }
        {
          name = "multi-account-containers";
          id = "@testpilot-containers";
        }
      ];
      DisableFormHistory = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      ExtensionUpdate = true;
    };
  };
}
