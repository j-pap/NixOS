{
  config,
  lib,
  pkgs,
  flk,
  ...
}:
let
  cfg = config.flake.gaming;
  stylix = config.stylix.enable;
  monitor = config.flake.host.monitor;

  gsRenicePkg = pkgs.writeShellScriptBin "gsr" ''
    (sleep 1; pgrep gamescope | xargs renice -n -20 -p)&
    exec gamescope "$@"
  '';
in
{
  options.flake.gaming.enable = lib.mkEnableOption "Gaming";

  config = lib.mkIf (cfg.enable) {
    boot.kernel.sysctl = {
      "net.ipv4.tcp_fin_timeout" = 5; # Faster timeout so games can reuse their TCP ports
      "vm.max_map_count" = lib.mkForce 2147483642; # Increase stability/performance of games
    };

    environment = {
      systemPackages = [
        gsRenicePkg # `gsr` binary to replace `gamescope` in launch options
      ]
      ++ builtins.attrValues {
        inherit (pkgs)
          jdk # Java games
          lutris # Game launcher - Epic, GOG, Humble Bundle, Steam
          protonplus # Proton-GE updater
          ;
      };
      variables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${flk.user}/.steam/steam/compatibilitytools.d";
        #STEAM_FORCE_DESKTOPUI_SCALING = lib.substring 0 4 monitor.scale; # Force "1.XX"
      };
    };

    #hardware.graphics.enable32Bit = true;

    home-manager.users.${flk.user} = {
      home.file = {
        # 'Legend of Dragoon' launcher
        "Games/Severed_Chains_Linux/launch" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.libGL}/lib
            cd ~/Games/Severed_Chains_Linux/
            ${lib.getExe' pkgs.jdk "java"} -cp "lod-game-cbb72c363c4425e53434bd75874d9d697a6cdda2.jar:libs/*" legend.game.Main -ea
          '';
        };

        # Steam's "Allow background processing of Vulkan shaders"
        ".steam/steam/steam_dev.cfg".text =
          let
            cpuCount = pkgs.runCommandLocal "cpu-count" { } "grep --count ^processor /proc/cpuinfo > $out";
          in
          ''
            unShaderBackgroundProcessingThreads ${lib.fileContents cpuCount}
          '';
      };

      programs.mangohud = {
        enable = true;
        enableSessionWide = false;
        settings = {
          ### Performance ###
          fps_limit = lib.toInt monitor.refresh;
          fps_limit_method = "late";
          vsync = 0;
          gl_vsync = -1;
          ### Visual ###
          time_no_label = true;
          gpu_text = "GPU";
          gpu_stats = true;
          gpu_load_change = true;
          gpu_load_value = "50,90";
          gpu_load_color = lib.mkIf (!stylix) "FFFFFF,FFAA7F,CC0000";
          gpu_temp = true;
          gpu_power = true;
          cpu_text = "CPU";
          cpu_stats = true;
          cpu_load_change = true;
          cpu_load_value = "50,90";
          cpu_load_color = lib.mkIf (!stylix) "FFFFFF,FFAA7F,CC0000";
          cpu_temp = true;
          cpu_power = true;
          vram = true;
          ram = true;
          fps = true;
          vulkan_driver = true;
          # Display GameMode status
          gamemode = true;
          # Display Gamescope options status
          fsr = true;
          hdr = true;
          # Display above Steam UI
          mangoapp_steam = false;
          position = "top-left";
          round_corners = 10;
          table_columns = 4;
          background_alpha = lib.mkForce 0.4;
          ### Interaction ###
          toggle_hud = "Shift_R+F12";
        };
      };
    };

    programs = {
      gamemode = {
        # Steam: Right-click game -> Properties -> Launch options: `gamemoderun gamescope -- %command%`
        # Lutris: Preferences -> Global options -> CPU -> Enable Feral GameMode
        enable = true;
        enableRenice = true;
        settings = {
          #custom.start = "${lib.getExe pkgs.libnotify} -a 'GameMode' -i 'input-gaming' 'GameMode Activated'";
          #custom.end = "${lib.getExe pkgs.libnotify} -a 'GameMode' -i 'input-gaming' 'GameMode Deactivated'";
          general = {
            inhibit_screensaver = 0; # Prevents errors when screensaver not installed
            renice = 20; # Game process priority
            reaper_freq = 5; # Reaper checks every 5 secs for updates
            softrealtime = "auto"; # Scheduler policy
          };
        };
      };

      gamescope = {
        enable = true;
        package = pkgs.gamescope.override { enableWsi = false; };
        # capSysNice currently prevents games from launching - "failed to inherit capabilities: Operation not permitted"
        #capSysNice = true; # Use `gsr` to replace `gamescope` in launch options mentioned above
        args = [
          "--output-width ${monitor.width}"
          "--output-height ${monitor.height}"
          #"--expose-wayland" # --mangoapp does not currently support Wayland
          "--rt" # Realtime scheduling
          "--framerate-limit ${monitor.refresh}"
          "--mangoapp"
          "--adaptive-sync" # VRR (if available)
          "--nested-width ${monitor.width}"
          "--nested-height ${monitor.height}"
          "--nested-refresh ${monitor.refresh}"
          "--nested-unfocused-refresh 30"
          #"--borderless"
          "--fullscreen"
          "--force-grab-cursor"
        ];
      };

      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraEnv.LD_PRELOAD = "${pkgs.gamemode.lib}/lib/libgamemode.so";
          extraPkgs =
            pkgs:
            # Gamescope fixes for undefined symbols in X11 session
            builtins.attrValues {
              inherit (pkgs)
                keyutils
                libkrb5
                libpng
                libpulseaudio
                libvorbis
                ;
              inherit (pkgs.xorg)
                libXcursor
                libXi
                libXinerama
                libXScrnSaver
                ;
              inherit (pkgs.stdenv.cc.cc) lib;
            };
        };
        extraCompatPackages = [
          #pkgs.proton-ge-bin
        ];
        extest.enable = true;

        # Firewall options
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };

    nixpkgs.overlays = [
      (final: prev: {
        lutris = prev.lutris.override {
          extraPkgs =
            pkgs:
            builtins.attrValues {
              inherit (pkgs)
                dxvk
                vkd3d
                winetricks
                ;
              inherit (pkgs.wineWow64Packages)
                wayland
                ;
            };
        };
      })
    ];

    # Gamemode process priority renice fix
    security.pam.loginLimits = lib.singleton {
      domain = "@gamemode";
      type = "-";
      item = "nice";
      value = -20; # Range from -20 to 19
    };

    users.users.${flk.user}.extraGroups = [ "gamemode" ];
  };
}
