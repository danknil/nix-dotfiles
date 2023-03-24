{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.desktop.addons.theming;
in
{
  # INFO: need to fill periodically with settings
  options.danknil.desktop.addons.theming = with types; {
    enable = mkBoolOpt false "Enable theming for gtk and qt. Also apply iconTheme where possible";
    iconTheme = {
      package = mkOpt package pkgs.materia-theme "Icon theme package";
      name = mkOpt str "Papirus-Dark" "Name of icon theme";
    };

    theme = {
      gtk = {
        package = mkOpt package pkgs.materia-theme "Theme package for gtk2/3/4";
        name = mkOpt str "Materia-dark" "Theme name for gtk2/3/4";
      };
      qt = {
        package = mkOpt package cfg.theme.gtk.package "Theme package for qt5/6. Defaults to gtk config";
        name = mkOpt str cfg.theme.gtk.name "Theme name for qt5/6. Defaults to gtk config";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-themes-extra
      gtk-engine-murrine
    ];
    danknil.home.extraOptions = {
      qt = {
        enable = true;
        style = cfg.theme.qt;
      };

      gtk = {
        enable = true;
        iconTheme = cfg.iconTheme;
        theme = cfg.theme.gtk;

        gtk2 = {
          # TODO: make configLocation work again
          # configLocation = "${config.xdg.configHome}" + /gtk-2.0/gtkrc;
        };
        gtk3 = {
          bookmarks = [ ];
        };
      };
    };
  };
}
