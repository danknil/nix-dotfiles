# FIXME: hyprpaper broken
{ lib
, pkgs
, config
, ...
}:
let cfg = config.profiles.desktop.hyprpaper;
in with lib; {
  options.profiles.desktop.hyprpaper = with types; { 
    enable = mkEnableOption "Enable Hyprpaper, simple wallpaper manager, designed for hyprland";
    extraConfig = dnix.mkOpt attrs {} "Default config overrides";
  };
  config = mkIf cfg.enable {
    home.packages = [ config.services.hyprpaper.package ];
    services.hyprpaper = {
      enable = true;
    } // cfg.extraConfig;
    # INFO: do i need this?
    # profiles.desktop.hyprland.extraConfig = {
    #   exec-once = [ "hyprpaper" ];
    # };
  };
}
