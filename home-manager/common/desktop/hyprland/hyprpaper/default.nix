{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) enabled';
  inherit (inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}) hyprpaper;
in {
  services.hyprpaper = enabled' {
    package = hyprpaper;
    settings = {
      ipc = "off";
      preload = ["${config.stylix.image}"];
      wallpaper = [
        " , ${config.stylix.image}"
      ];
    };
  };
}
