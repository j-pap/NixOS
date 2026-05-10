{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.git;
in
{
  options.flake.git = {
    libsecret.enable = lib.mkEnableOption "Git via Libsecret";
    oauth.enable = lib.mkEnableOption "Git via Oauth";
    ssh.enable = lib.mkEnableOption "Git via SSH" // {
      default = true;
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.libsecret.enable && cfg.oauth.enable);
        message = "(Git) Libsecret and OAuth may not be used at the same time.";
      }
      {
        assertion = !(cfg.libsecret.enable && cfg.ssh.enable);
        message = "(Git) Libsecret and SSH may not be used at the same time.";
      }
      {
        assertion = !(cfg.oauth.enable && cfg.ssh.enable);
        message = "(Git) OAuth and SSH may not be used at the same time.";
      }
    ];

    home-manager.users.${flk.user} = lib.mkMerge [
      {
        programs.git = {
          enable = true;
          settings = {
            init.defaultBranch = "main";
            user = {
              email = "205946337+j-pap@users.noreply.github.com";
              name = "j-pap";
            };
          };
        };
      }

      # "git-credential-libsecret" stores credentials inside gnome-keyring / kde-wallet
      # Gnome relies upon 'gnome-keyring' and 'seahorse'
      # KDE relies upon 'kwallet', 'kwallet-pam', and 'kwalletmanager'
      (lib.mkIf (cfg.libsecret.enable) {
        programs.git.settings.credential.helper = lib.getExe' pkgs.git.override {
          withLibsecret = true;
        } "git-credential-libsecret";
      })

      (lib.mkIf (cfg.oauth.enable) {
        programs.git-credential-oauth.enable = true;
      })

      (lib.mkIf (cfg.ssh.enable) {
        programs = {
          git = {
            settings = {
              commit.gpgsign = true;
              gpg = {
                format = "ssh";
                ssh.program =
                  if (flk."1password".enable) then
                    (lib.getExe' pkgs._1password-gui "op-ssh-sign")
                  else
                    (lib.getExe' pkgs.openssh "ssh-keygen");
              };
              user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdsPgO+W30YwojR6rmyFQ7JOoracCgncClxVUAkTNoJ";
            };
            signing.format = if (flk."1password".enable) then null else "ssh";
          };

          ssh =
            let
              hosts = [
                "FW13"
                "T1"
                "T450s"
              ];
              identityAgent =
                if (flk."1password".enable) then
                  "/home/${flk.user}/.1password/agent.sock"
                else
                  (lib.getExe' pkgs.openssh "ssh-agent");
            in
            {
              enable = true;
              matchBlocks =
                builtins.listToAttrs (
                  builtins.map (host: {
                    name = host;
                    value = {
                      identityAgent = identityAgent;
                      forwardAgent = true;
                    };
                  }) hosts
                )
                // {
                  "github.com".match = ''
                    host github.com exec "test -z $SSH_TTY"
                      IdentityAgent ${identityAgent}
                  '';
                };
            };
        };
      })
    ];
  };
}
