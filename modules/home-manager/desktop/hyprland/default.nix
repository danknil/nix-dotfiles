{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.profiles.desktop.hyprland;
in {
  options.profiles.desktop.hyprland = with lib; {
    enable = mkEnableOption "Enable Hyprland Wayland Compositor";
    extraConfig = dnix.mkOpt types.attrs {} "add extra config for enable some custom functionality (output and input setups)";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = lib.dnix.recursiveMerge [
        {
          "$mainMod" = "SUPER";

          "exec-once" = [];
          "exec" = [];

          xwayland.force_zero_scaling = false;

          env = [
            # Set env vars
            "XCURSOR_SIZE,24"
            # XDG vars
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            # QT vars
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_QPA_PLATFORMTHEME,qt5ct"
            # GTK vars
            "GDK_BACKEND,wayland,x11"
            # Misc vars
            "SDL_VIDEODRIVER,wayland"
            "CLUTTER_BACKEND,wayland"
          ];

          input = {
            follow_mouse = 1;
            touchpad.natural_scroll = true;
            sensitivity = 0;
          };

          general = with config.colorscheme.palette; {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = "5";
            gaps_out = "10";
            border_size = "6";
            "col.active_border" = "rgb(${base00})";
            "col.inactive_border" = "rgb(${base05})";

            layout = "dwindle";

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false;
          };

          decoration = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = "5";

            blur = {
              enabled = true;
              size = "3";
              passes = "1";
            };

            drop_shadow = "true";
            shadow_range = "4";
            shadow_render_power = "3";
            "col.shadow" = "rgba(1a1a1aee)";
          };

          animations = {
            enabled = true;

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          gestures.workspace_swipe = true;

          misc = {
            force_default_wallpaper = "0";
            disable_splash_rendering = true;
            disable_hyprland_logo = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            vrr = "1";
          };

          windowrulev2 = [
            # xwaylandvideobridge
            "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
            "noanim,class:^(xwaylandvideobridge)$"
            "nofocus,class:^(xwaylandvideobridge)$"
            "noinitialfocus,class:^(xwaylandvideobridge)$"

            # telegram media preview fullscreen
            "float,class:^(org.telegram.desktop)$,title:^(Просмотр медиа)$"
            "fullscreen,class:^(org.telegram.desktop)$,title:^(Просмотр медиа)$"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          bind =
            [
              "$mainMod, T, exec, $TERM"

              # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
              "$mainMod, C, killactive,"
              "$mainMod, M, exit,"
              "$mainMod, E, exec, dolphin"
              "$mainMod, V, togglefloating,"

              # Move focus with mainMod + arrow keys
              "$mainMod, left, movefocus, l"
              "$mainMod, right, movefocus, r"
              "$mainMod, up, movefocus, u"
              "$mainMod, down, movefocus, d"
              # Move focus with mainMod + hjkl keys
              "$mainMod, H, movefocus, l"
              "$mainMod, L, movefocus, r"
              "$mainMod, K, movefocus, u"
              "$mainMod, J, movefocus, d"

              "$mainMod, RETURN, fullscreen, 0"

              # Example special workspace (scratchpad)
              "$mainMod, S, togglespecialworkspace, magic"
              "$mainMod SHIFT, S, movetoworkspace, special:magic"

              # Scroll through existing workspaces with mainMod + scroll
              "$mainMod, mouse_down, workspace, e+1"
              "$mainMod, mouse_up, workspace, e-1"
            ]
            ++ (
              # workspaces
              # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
              builtins.concatLists (builtins.genList
                (
                  x: let
                    ws = let
                      c = (x + 1) / 10;
                    in
                      builtins.toString (x + 1 - (c * 10));
                  in [
                    "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                    "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                  ]
                )
                10)
            );
        }
        cfg.extraConfig
      ];
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
      config = {
        preferred = {
          default = ["hyprland" "kde" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["kde"];
        };
      };
    };
  };
}
