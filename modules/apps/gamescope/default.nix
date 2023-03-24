{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.gamescope;
in
{
  options.danknil.apps.gamescope = with types; {
    enable = mkBoolOpt false "Enable gamescope";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gamescope
    ];
  };
}
