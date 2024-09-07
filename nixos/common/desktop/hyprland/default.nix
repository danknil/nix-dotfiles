{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) enabled enabled';
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.hyprland = enabled' {
    package = hyprland.hyprland;
    portalPackage = hyprland.xdg-desktop-portal-hyprland;
  };
}
