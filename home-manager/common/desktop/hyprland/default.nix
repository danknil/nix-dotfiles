{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) enabled' mkForce;
  inherit (config.lib.stylix) colors;
  inherit (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}) hyprland;
in {
  imports = [
    ./lock
    ./ags
    ./anyrun
    ./hyprpaper
  ];

  home.packages = with pkgs; [dolphin];

  wayland.windowManager.hyprland = enabled' {
    package = hyprland;
    settings = {
      "$mainMod" = "SUPER";

      "$terminal" = "alacritty";
      "$filemanager" = "dolphin";
      "$menu" = "anyrun";

      monitor = ",preferred,auto,auto";

      general = with colors; {
        border_size = 5;
        "col.active_border" = mkForce "rgb(${base05}) rgb(${base06}) 22deg";
        "col.inactive_border" = mkForce "rgb(${base00}) rgb(${base03}) 22deg";
        "col.nogroup_border" = mkForce "rgb(${base00}) rgb(${base03}) 22deg";
        "col.nogroup_border_active" = mkForce "rgb(${base00}) rgb(${base03}) 22deg";
      };
      decoration = {
        rounding = 0;
        blur.enabled = false;
      };
      input = {
        kb_layout = "us,ru";
        repeat_rate = 25;
        repeat_delay = 600;
        accel_profile = "adaptive";
        scroll_method = "2fg";
        touchpad = {
          natural_scroll = true;
          drag_lock = true;
        };
      };
      gestures = {
        workspace_swipe = true;
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
      bind =
        [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, $menu"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Example special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mainMod, code:1${toString i}, workspace, ${toString ws}"
                "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
