{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.discord;
in
{
  options.danknil.apps.discord = with types; {
    enable = mkBoolOpt false "Enable discord";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord-canary
    ];
  };
}
