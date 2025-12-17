{
  pkgs,
  inputs,
  cosmicLib,
  ...
}: {
  wayland.desktopManager.cosmic = let
    ron = rec {
      make = cosmicLib.cosmic.mkRON;
      from = cosmicLib.cosmic.fromRON;
      option = make "optional";
      enum = make "enum";
      tuple = make "tuple";
      raw = make "raw";
      valueEnum = variant: value:
        enum {
          inherit variant;
          value =
            if builtins.isList value
            then value
            else [value];
        };
    };
  in {
    enable = true;

    configFile = {
      "com.system76.CosmicSettings.Shortcuts" = {
        entries = {
          system_actions = {
            Terminal = "kitty";
          };
        };
        version = 1;
      };
      "com.system76.CosmicTerm" = {
        entries = {
          font_name = "JetBrains Mono";
          font_size = 16;
        };
        version = 1;
      };
    };

    appearance.theme = let
      rose-pine = inputs.rose-pine-cosmic.packages.${pkgs.stdenv.hostPlatform.system}.default;
      readTheme = variant: let
        content = builtins.readFile "${rose-pine}/${variant}/cosmic-settings.ron";
        theme = ron.from content;
      in
        theme.palette;
    in {
      light.palette = readTheme "dawn";
      dark.palette = readTheme "moon";
    };

    compositor = {
      active_hint = true;
      autotile = true;
      autotile_behavior = ron.enum "PerWorkspace";

      descale_xwayland = true;
      edge_snap_threshold = 0;

      cursor_follows_focus = true;
      focus_follows_cursor = true;
      focus_follows_cursor_delay = 250;

      workspaces = {
        workspace_layout = ron.enum "Horizontal";
        workspace_mode = ron.enum "OutputBound";
      };

      xkb_config = {
        layout = "us";
        model = "pc104";
        options = ron.option "terminate:ctrl_alt_bksp";
        repeat_delay = 600;
        repeat_rate = 25;
        rules = "";
        variant = "";
      };
    };

    # wallpapers = [
    #   {
    #     filter_by_theme = true;
    #     filter_method = ron.enum "Lanczos";
    #     output = "all";
    #     rotation_frequency = 600;
    #     sampling_method = ron.enum "Alphanumeric";
    #     scaling_mode = ron.enum "Zoom";
    #     source = ron.enum {
    #       variant = "Path";
    #       value = [../../wallpaper];
    #     };
    #   }
    # ];

    shortcuts = [
      # disable some default keybindings
      {
        key = "Super";
        action = ron.enum "Disable";
      }
      {
        key = "Super+q";
        action = ron.enum "Disable";
      }
      {
        key = "Super+Escape";
        action = ron.enum "Disable";
      }
      {
        key = "Super+slash";
        action = ron.enum "Disable";
      }

      {
        key = "Super+w";
        action = ron.enum "Close";
      }

      {
        key = "Super+Alt+h";
        action = ron.valueEnum "Resize" (ron.enum "Left");
      }
      {
        key = "Super+Alt+j";
        action = ron.valueEnum "Resize" (ron.enum "Down");
      }
      {
        key = "Super+Alt+k";
        action = ron.valueEnum "Resize" (ron.enum "Up");
      }
      {
        key = "Super+Alt+l";
        action = ron.valueEnum "Resize" (ron.enum "Right");
      }

      {
        key = "Super+n";
        action = ron.enum "Minimize";
      }

      {
        key = "Super+Shift+W";
        description = ron.option "Open Librewolf";
        action = ron.valueEnum "Spawn" "librewolf";
      }

      {
        key = "Super+space";
        action = ron.valueEnum "System" (ron.enum "Launcher");
      }

      {
        key = "Super+Shift+q";
        action = ron.valueEnum "System" (ron.enum "LogOut");
      }
    ];
  };
}
