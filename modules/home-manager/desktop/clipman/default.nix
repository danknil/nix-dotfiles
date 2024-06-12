{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.profiles.desktop.clipman;
in
  with lib;
  with lib.dnix; {
    options.profiles.desktop.clipman = with types; {
      enable = mkEnableOption "clipman";
    };
    config = mkIf cfg.enable {
      services.clipman = enabled;
      home.packages = [pkgs.wl-clipboard];
    };
  }
