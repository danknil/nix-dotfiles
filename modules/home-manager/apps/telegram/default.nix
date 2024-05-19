{ lib
, pkgs
, config
, ...
}:
with lib;
with lib.dnix;
let
  cfg = config.apps.telegram;
in
{
  options.apps.telegram = {
    enable = mkEnableOption "telegram";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.telegram-desktop ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
    };
  };
}
