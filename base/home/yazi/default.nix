{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  flk = osConfig.flake;
  stylix = osConfig.stylix;
in
{
  imports = [ ./plugins ];

  programs.yazi = {
    enable = true;
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        blobdrop
        #dragon-drop
        wl-clipboard
        ;
    };
    enableBashIntegration = true;
    shellWrapperName = "y";
    flavors = lib.mkIf (!stylix.enable) pkgs.yaziFlavors;
    theme.flavor = lib.optionalAttrs (!stylix.enable) {
      dark = lib.toLower flk.host.theme.dark;
      light = lib.toLower flk.host.theme.light;
    };

    keymap = {
      input.prepend_keymap = [
        # Close input w/ one <Esc>
        {
          desc = "Cancel input";
          on = "<Esc>";
          run = "close";
        }
      ];

      mgr.prepend_keymap = [
        # Open a shell in $PWD
        {
          desc = "Open $SHELL here";
          for = "unix";
          on = "!";
          run = "shell \"$SHELL\" --block";
        }

        # Copy selected files to the system clipboard while yanking
        {
          desc = "Copy selected files to system clipboard";
          on = "y";
          run = [
            "shell -- for path in %s; do echo \"file://$path\"; done | wl-copy -t text/uri-list"
            "yank"
          ];
        }

        # cd to NixOS config files
        {
          desc = "Goto NixOS config";
          on = [
            "g"
            "n"
          ];
          run = "cd /etc/nixos";
        }

        # cd back to the root of the current Git repository
        {
          desc = "Goto root of current Git repo";
          on = [
            "g"
            "r"
          ];
          run = "shell -- ya emit cd \"$(git rev-parse --show-toplevel)\"";
        }

        # Drag & drop files
        {
          desc = "Drag/drop files";
          on = "<C-n>";
          #run = "shell -- dragon-drop -x -i -T %s";
          run = "shell -- blobdrop -x -t %s";
        }

        # Email files
        {
          desc = "Send selected files using Thunderbird";
          on = "<C-m>";
          run = ''
            shell --
            paths=$(for p in %s; do echo "$p"; done | paste -s -d,)
            thunderbird -compose "attachment='$paths'"
          '';
        }
      ];
    };

    settings = {
      input.cursor_blink = true;

      mgr = {
        show_symlink = true;
        sort_by = "natural";
        sort_dir_first = true;
      };

      open = {
        prepend_rules = [
          {
            mime = "image/*";
            use = [
              "open"
              "set-wallpaper"
            ];
          }
        ];
      };

      # Mimetypes are ignored/'Choose application' pops up when 'config.xdg.portal.xdgOpenUsePortal = true;'
      opener =
        let
          xdgCmd = "xdg-open %s";
        in
        {
          edit = lib.singleton {
            desc = "Edit";
            block = true;
            run = "$EDITOR %s";
          };
          open = lib.singleton {
            desc = "Open";
            orphan = true;
            run = xdgCmd;
          };
          play = lib.singleton {
            desc = "Play";
            orphan = true;
            run = xdgCmd;
          };
          set-wallpaper = lib.singleton {
            desc = "Set as wallpaper";
            for = "linux";
            run =
              if (flk.de.cosmic.enable) then
                ""
              else if (flk.de.gnome.enable) then
                "gsettings set org.gnome.desktop.background picture-uri %s1"
                #"gsettings set org.gnome.desktop.background picture-uri-dark %s1"
              else if (flk.de.kde.enable) then
                "plasma-apply-wallpaperimage %s1"
              else if (flk.de.hyprland.enable) then
                "awww img %s1"
              else
                "";
          };
        };

      plugin = {
        # Disable network pre-load/view
        prepend_preloaders = lib.singleton {
          name = "/mnt/nas/**";
          run = "noop";
        };
        prepend_previewers = lib.singleton {
          name = "/mnt/nas/**";
          run = "noop";
        };
      };

      preview = {
        tab_size = 2;
        wrap = "yes";
      };
    };
  };
}
