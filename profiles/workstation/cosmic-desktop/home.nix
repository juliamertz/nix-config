inputs:
{
  pkgs,
  cosmicLib,
  ...
}:
{
  wayland.desktopManager.cosmic =
    let

      ron = rec {
        make = cosmicLib.cosmic.mkRON;
        from = cosmicLib.cosmic.fromRON;
        option = make "optional";
        enum = make "enum";
        valueEnum =
          variant: value:
          enum {
            inherit variant;
            value = if builtins.isList value then value else [ value ];
          };
      };

    in
    {
      enable = true;

      appearance.theme =
        let
          rose-pine = inputs.rose-pine-cosmic.packages.${pkgs.system}.default;
          readTheme =
            variant:
            let
              content = builtins.readFile "${rose-pine}/${variant}/cosmic-settings.ron";
              theme = ron.from content;
            in
            theme.palette;
        in
        {
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
