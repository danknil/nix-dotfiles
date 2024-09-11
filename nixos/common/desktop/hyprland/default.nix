{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) enabled';
  inherit (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}) hyprland xdg-desktop-portal-hyprland;
in {
  security.pam.services.hyprlock = {};
  programs.hyprland = enabled' {
    package = hyprland;
    portalPackage = xdg-desktop-portal-hyprland;
  };
}
