{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) enabled';
  inherit (config.lib.stylix) colors;
  inherit (inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}) hypridle;
  inherit (inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}) hyprlock;
in {
  services.hypridle = enabled' {
    package = hypridle;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        lock_cmd = "${hyprlock}/bin/hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "${hyprlock}/bin/hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  programs.hyprlock = enabled' {
    package = hyprlock;
    settings = with colors; {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = config.stylix.image;
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };
}
