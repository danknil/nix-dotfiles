{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) enabled';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    # we should set this on system level
    package = null;
    settings = {
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
