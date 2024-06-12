{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.desktop.wbg;
in
  with lib; {
    options.profiles.desktop.wbg = with types; {
      enable = mkEnableOption "Enable wbg, simple wallpaper application";
      wallpaperImg = dnix.mkOpt str "~/Wallpapers/default.png" "Set wallpaper to use on all screens";
    };
    config = mkIf cfg.enable {
      home.packages = [pkgs.wbg];
      profiles.desktop.hyprland.extraConfig = {
        exec-once = ["wbg ${cfg.wallpaperImg}"];
      };
    };
  }
