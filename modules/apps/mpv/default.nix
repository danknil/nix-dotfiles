{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.mpv;
in
{
  options.danknil.apps.mpv = with types; {
    enable = mkBoolOpt false "Enable mpv player";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mpv
    ];
    danknil.home.extraOptions = {
      programs.mpv = {
        enable = true;
        config = { };
        scripts = with pkgs.mpvScripts; [
          uosc
          mpris
          sponsorblock
          youtube-quality
        ];
      };
    };
  };
}
