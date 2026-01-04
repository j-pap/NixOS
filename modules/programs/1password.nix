{
  config,
  lib,
  browser,
  myUser,
  ...
}:
let
  cfg = config.flake."1password";
in
{
  options.flake."1password".enable = lib.mkEnableOption "1Password";

  config = lib.mkIf (cfg.enable) {
    # Allow _1password-gui to communicate w/ the browser extension
    environment.etc."1password/custom_allowed_browsers" = {
      mode = "0755";
      text = browser;
    };

    home-manager.users.${myUser}.xdg.configFile."autostart/1password.desktop".text =
      let
        opPkg = config.programs._1password-gui.package;
      in
      lib.replaceStrings [ "Exec=1password %U" ] [ "Exec=${lib.getExe opPkg} --silent %U" ] (
        lib.fileContents "${opPkg}/share/applications/1password.desktop"
      );

    programs = {
      _1password.enable = false; # CLI
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ myUser ];
      };
    };

    users.users.${myUser}.extraGroups = [ "onepassword" ];
  };
}
