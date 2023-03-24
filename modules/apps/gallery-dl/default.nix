{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.gallery-dl;
in
{
  options.danknil.apps.gallery-dl = with types; {
    enable = mkBoolOpt false "Enable gallery-dl";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gallery-dl ];
    danknil.home.extraOptions = {
      programs.gallery-dl = {
        enable = true;
      };
    };
  };
}
