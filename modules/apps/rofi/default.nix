{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.rofi;
in
{
  options.danknil.apps.rofi = with types; {
    enable = mkBoolOpt false "Enable rofi";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rofi-wayland ];
    danknil.home.extraOptions = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        plugins = with pkgs; [
          rofi-emoji
          rofi-calc
          keepmenu
        ];
      };
    };
  };
}
