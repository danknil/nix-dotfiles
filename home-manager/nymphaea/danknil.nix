{ lib
, pkgs
, ...
}:
with lib.dnix;
{
  snowfallorg.user = enabled' {
    name = "danknil";
  };

  colorscheme.name = "gruvbox-light-medium";

  profiles = {
    desktop = {
      # hyprland wm config
      hyprland = enabled' {
        extraConfig = {
          monitor = "eDP-1,preferred,0x0,1";
          device = [
            {
              name = "at-translated-set-2-keyboard";
              kb_layout = "us,ru";
              kb_variant = "";
              kb_model = "";
              kb_options = "grp:caps_toggle";
              kb_rules = "";
            }
          ];
        };
      };
      # FIXME: broken atm
      # hyprpaper = {
      #   enable = true;
      #   extraConfig = {
      #     preloads = [ "~/Wallpapers/saber-dark.png" ];
      #     wallpapers = [ "eDP-1,~/Wallpapers/saber-dark.png" ];
      #   };
      # };

      hypridle = enabled;
      clipman = enabled;
      hyprshot = enabled;
      ags = enabled;
      rofi = enabled;
      wbg = enabled' {
        wallpaperImg = "~/Wallpapers/saber-dark.png";
      };
    };
    shell = enabled;
  };

  apps = {
    # programs setups
    alacritty = enabled;
    vivaldi = enabled;
    neovim = enabled;
    mpv = enabled;
  };

  home.packages = with pkgs; [
    nomacs # image viewer
    vesktop # discord client
    telegram-desktop # telegram client
    zapzap # whatsapp client
    obsidian # note taking
    onlyoffice-bin # office suit
  ];

  # gtk.iconTheme = {
  #   package = pkgs.numix-icon-theme;
  #   name = "Numix";
  # };
  services = {
    udiskie = enabled' {
      tray = "never";
    };
    syncthing = enabled;
  };

  home.stateVersion = "23.11";
}
