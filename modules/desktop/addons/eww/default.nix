{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.eww;
in
{
  options.danknil.apps.eww = with types; {
    enable = mkBoolOpt false "Enable eww";
    enableBar = mkBoolOpt cfg.enable "Enable bar made by eww";
    enablePowermenu = mkBoolOpt cfg.enable "Enable powermenu made by eww";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.eww-wayland ];
    danknil.home.extraOptions = {
      programs.eww = {
        enable = true;
        package = null;
      };
    };
  };
}
