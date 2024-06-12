{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.clifm;
in
  with lib; {
    options.apps.clifm = {
      enable = mkEnableOption "Enable clifm - command line file manager";
    };
    config = lib.mkIf cfg.enable {
      home.packages = [pkgs.clifm];
    };
  }
