{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.desktop.hypridle;
  listeners =
    if cfg.listeners != null
    then cfg.listeners
    else
      [
        {
          timeout = 120; # 2 minutes
          onTimeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          onResume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 300; # 5 minutes
          # should always work
          onTimeout = "loginctl lock-session";
        }
        {
          timeout = 900; # 15 minutes
          onTimeout = "systemctl suspend-then-hibernate";
        }
      ]
      ++ lib.optional config.profiles.desktop.hyprland.enable {
        timeout = 330; # 5.5 minutes
        # works only with hyprland
        onTimeout = "hyprctl dispatch dpms off";
        onResume = "hyprctl dispatch dpms on";
      };
in
  with lib;
  with lib.dnix; {
    options.profiles.desktop.hypridle = {
      enable = mkEnableOption "Enable hypridle, idler for hyprland";
    };

    config = mkIf cfg.enable {
      services.hypridle = enabled' {
        inherit listeners;
        lockCmd = "pidof hyprlock || hyprlock";
        beforeSleepCmd = "loginctl lock-session";
        afterSleepCmd = "hyprctl dispatch dpms on";
      };
      programs.hyprlock = enabled;
      profiles.desktop.hyprland.extraConfig = {
        bind = ["$mainMod SHIFT, L, exec, loginctl lock-session"];
      };
    };
  }
