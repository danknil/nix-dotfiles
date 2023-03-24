{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.gamemode;
in
{
  options.danknil.apps.gamemode = with types; {
    enable = mkBoolOpt false "Enable gamemode";
    # settings = mkOpt attr {} "Settings gamemode is using";
  };

  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      # inherit (cfg) settings;
    };
  };
}
