{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.spotify;
in
{
  options.danknil.apps.spotify = with types; {
    enable = mkBoolOpt false "Enable spotify";
  };

  # TODO: use spicetify to setup addons for spotify + add spotify fix for wayland
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotify
    ];
  };
}
