{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.profiles.desktop.hyprshot;
in
with lib; {
  options.profiles.desktop.hyprshot = {
    enable = mkEnableOption "Enable hyprshot, screenshoter for hyprland";
    enablePicker = mkEnableOption "Enable hyprpicker for color picking";
  };

  config = mkIf cfg.enable {
    # TODO: setup picker
    home.packages = [ pkgs.hyprshot ];
    profiles.desktop.hyprland.extraConfig = {
      bind = [
        "$mainMod SHIFT, S, exec, hyprshot -m region"
        "SHIFT, Print, exec, hyprshot -c -m output"
        #"$mainMod CTRL, Print, exec, hyprshot -c -m window"
      ];
    };
  };
}
