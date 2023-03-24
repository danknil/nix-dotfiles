{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.obs-studio;
in
{
  options.danknil.apps.obs-studio = with types; {
    enable = mkBoolOpt false "Enable obs-studio";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.obs-studio ];
    danknil.home.extraOptions = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          droidcam-obs
          obs-vkcapture
          obs-gstreamer
          input-overlay
          obs-multi-rtmp
          obs-move-transition
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}
