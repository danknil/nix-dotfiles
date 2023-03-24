{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.yt-dlp;
in
{
  options.danknil.apps.yt-dlp = with types; {
    enable = mkBoolOpt false "Enable yt-dlp";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.yt-dlp ];
    danknil.home.extraOptions = {
      programs.yt-dlp = {
        enable = true;
      };
    };
  };
}
