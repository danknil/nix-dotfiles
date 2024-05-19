{ lib
, pkgs
, config
, ...
}:
with lib;
with lib.dnix;
let
  cfg = config.profiles.desktop.ags;
  colors =
    with config.colorscheme.palette;
    builtins.concatStringsSep "\n"
      (attrsets.mapAttrsToList
        (name: value: "@define-color ${name} #${value};")
        config.colorscheme.palette);
in
{
  options.profiles.desktop.ags = with lib; {
    enable = mkEnableOption "Enable ags with notifications and bar";
  };
  config = lib.mkIf cfg.enable {
    # install fonts
    fonts.packages = with pkgs; [
      ubuntu_font_family
      jetbrains-mono
    ];

    # manage ags by myself, because hm module cant do what i want
    xdg.configFile = {
      "ags/colors.css".text = colors;
      "ags/style.css".source = ./config/style.css;
      "ags/config.js".source = ./config/config.js;
      "ags/package.json".source = ./config/package.json;
      "ags/src".source = ./config/src;
    };

    programs.ags = {
      enable = true;
      # null or path, leave as null if you don't want hm to manage the config
      configDir = null;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
    profiles.desktop.hyprland.extraConfig = {
      exec-once = [ "ags" ];
    };
  };
}
