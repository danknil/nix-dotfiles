{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) enabled';
  colors =
    builtins.concatStringsSep "\n"
    (lib.attrsets.mapAttrsToList
      (name: value: "@define-color ${name} ${value};")
      config.lib.stylix.colors.withHashtag);
in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];
  # install fonts
  home.packages = with pkgs; [
    ubuntu_font_family
    jetbrains-mono
  ];

  # # manage ags by myself, because hm module cant do what i want
  # xdg.configFile = {
  #   "ags/colors.css".text = colors;
  #   "ags/style.css".source = ./config/style.css;
  #   "ags/config.js".source = ./config/config.js;
  #   "ags/package.json".source = ./config/package.json;
  #   "ags/src".source = ./config/src;
  # };
  #
  # programs.ags = enabled' {
  #   configDir = null;
  #
  #   # additional packages to add to gjs's runtime
  #   extraPackages = with pkgs; [
  #     gtksourceview
  #     webkitgtk
  #     accountsservice
  #   ];
  # };
}
