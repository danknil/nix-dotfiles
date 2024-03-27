{ pkgs
, ...
}:
{
  snowfallorg.user = {
    enable = true;
    name = "danknil";
  };
  profiles = {
    desktop = {
      # hyprland wm config
      hyprland = {
        enable = true;
        extraConfig = {
          monitor = "eDP-1,preferred,0x0,1";
          debug = {
            disable_logs = false;
            enable_stdout_logs = true;
          };
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

      hypridle.enable = true;
      wbg = {
        enable = true;
        wallpaperImg = "~/Wallpapers/saber-dark.png";
      };

      # desktop programs
      rofi.enable = true;
      hyprshot.enable = true;
      ags.enable = true;
    };

    # programs setups
    alacritty.enable = true;
    zsh.enable = true;
  };

  home.packages = with pkgs; [
    # atool
    atool
    gnutar
    gzip
    pbzip2
    plzip
    lzop
    lzip
    zip
    unzip
    rar
    lha
    p7zip
    # cp & mv but better
    advcpmv

    # my app
    dnix.mimeappslist
  ];

  gtk.iconTheme = {
    package = pkgs.numix-icon-theme;
    name = "Numix";
  };

  services.udiskie = {
    enable = true;
    tray = "never";
  };

  home.stateVersion = "23.11";
}
