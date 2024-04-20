{ lib
, pkgs
, config
, ...
}:
let cfg = config.profiles.desktop.rofi;
in {
  options.profiles.desktop.rofi = with lib; {
    enable = mkEnableOption "Enable rofi";
  };
  config = lib.mkIf cfg.enable {
    profiles.desktop.hyprland.extraConfig.bind = [
      "$mainMod, R, exec, rofi -show drun"
    ];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      # TODO: add config
      extraConfig = { };
    };
  };
}
