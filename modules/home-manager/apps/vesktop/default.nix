{ lib
, pkgs
, config
, ...
}:
with lib;
with lib.dnix;
let
  cfg = config.apps.vesktop;
in
{
  options.apps.vesktop = {
    enable = mkEnableOption "Vesktop";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.vesktop ];
  };
}
