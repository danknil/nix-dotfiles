{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) enabled';
  inherit (config.lib.stylix) colors;
in {
  imports = [
    ./lock
    ./ags
    ./anyrun
    ./hyprpaper
  ];

  wayland.windowManager.hyprland = enabled' {
    package = null;
    settings = {
      general = with colors; {
        "col.active_border" = "rgb(${base05}) rgb(${base06}) 22deg";
        "col.inactive_border" = "rgb(${base00}) rgb(${base03}) 22deg";
        "col.nogroup_border" = "rgb(${base00}) rgb(${base03}) 22deg";
        "col.nogroup_border_active" = "rgb(${base00}) rgb(${base03}) 22deg";
      };
      # TODO: fix coloring
      decoration = {
        rounding = 0;
        blur.enable = false;
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
    };
  };
}
