{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.qutebrowser;
in
{
  options.danknil.apps.qutebrowser = with types; {
    enable = mkBoolOpt false "Enable qutebrowser";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qutebrowser ];
    danknil.home.extraOptions = {
      programs.qutebrowser = {
        enable = true;
      };
    };
  };
}
