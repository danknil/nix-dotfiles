{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) enabled';
in {
  programs.obs-studio = enabled' {
    plugins = with pkgs.obs-studio-plugins; [
      obs-websocket
      obs-vkcapture
      obs-pipewire-audio-capture
      droidcam-obs
    ];
  };
}
