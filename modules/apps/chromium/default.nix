{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.chromium;
in
{
  options.danknil.apps.chromium = with types; {
    enable = mkBoolOpt false "Enable chromium";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      chromium
    ];
  };
}
