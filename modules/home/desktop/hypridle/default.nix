{ lib
, pkgs
, config
, ...
}:
let cfg = config.profiles.desktop.hypridle;
in with lib; {
  options.profiles.desktop.hypridle = {
    enable = mkEnableOption "Enable hypridle, idler for hyprland";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      listeners = [
        {
          timeout = 120; # 2 minutes
          onTimeout = "brightnessctl -s set 10";
          onResume = "brightnessctl -r";
        }
        {
          timeout = 300; # 5 minutes
          onTimeout = "loginctl lock-session";
        }
        {
          timeout = 330; # 5.5 minutes
          onTimeout = "hyprctl dispatch dpms off";
          onResume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 900; # 15 minutes
          onTimeout = "systemctl suspend-then-hibernate";
        }
      ];
      lockCmd = "pidof hyprlock || hyprlock";
      beforeSleepCmd = "loginctl lock-session";
      afterSleepCmd = "hyprctl dispatch dpms on";
    };
    programs.hyprlock = {
      enable = true;
    };
    profiles.desktop.hyprland.extraConfig = {
      bind = [ "$mainMod SHIFT, L, exec, loginctl lock-session" ];
    };
  };
}
