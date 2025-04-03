{
  lib,
  pkgs,
  ...
}: {
  #'@search.mozilla.orgdefault' must be appended to all default search engine ids when using Floorp
    # https://github.com/nix-community/home-manager/issues/6728
  default = "startpage@search.mozilla.orgdefault";
  force = true;
  privateDefault = "google@search.mozilla.orgdefault";

  engines = {
    "bing@search.mozilla.orgdefault".metaData.hidden = true;
    "you.com@search.mozilla.orgdefault".metaData.hidden = true;

    home-manager-options = {
      name = "Home Manager Options";
      definedAliases = [ "@hm" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
        template = "https://home-manager-options.extranix.com/";
        params = [
          {
            name = "query";
            value = "{searchTerms}";
          }
          {
            name = "release";
            value = "master";
          }
        ];
      };
    };

    nix-packages = {
      name = "Nix Packages";
      definedAliases = [ "@np" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
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
      };
    };

    nixos-options = {
      name = "NixOS Options";
      definedAliases = [ "@no" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
        template = "https://search.nixos.org/options";
        params = [
          {
            name = "channel";
            value = "unstable";
          }
          {
            name = "type";
            value = "options";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      };
    };

    nixos-wiki = {
      name = "NixOS Wiki";
      definedAliases = [ "@nw" ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      urls = lib.singleton {
        template = "https://wiki.nixos.org/wiki/{searchTerms}";
      };
    };
  };

}
