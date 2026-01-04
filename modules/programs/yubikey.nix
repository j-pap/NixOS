{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.flake.yubikey;
in
{
  options.flake.yubikey.enable = lib.mkEnableOption "Yubikey(s)";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        yubioath-flutter        # Yubico Authenticator
        yubikey-manager         # CLI config tool | 'ykman'
        yubikey-personalization # CLI personalize | 'ykpersonalize'
        ;
    };

    programs.yubikey-touch-detector.enable = true;

    services = {
      pcscd.enable = true; # Enable smart cards
      udev.packages = [ pkgs.yubikey-personalization ];
    };
  };
}
