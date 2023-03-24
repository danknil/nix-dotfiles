{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.obsidian;
in
{
  options.danknil.apps.obsidian = with types; {
    enable = mkBoolOpt false "Enable obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}

