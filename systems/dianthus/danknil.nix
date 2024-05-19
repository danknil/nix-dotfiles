{ lib
, pkgs
, ...
}:
with lib.dnix;
{
  snowfallorg.user = enabled' {
    name = "danknil";
  };

  colorSchemeName = "gruvbox-material-light-medium";

  profiles = {
    desktop = {
      # hyprland wm config
      hyprland = enabled' {
        extraConfig = {
          monitor = [
            "DP-1,preferred,0x0,1"
            "HDMI-A-1,preferred,2560x-400,1,transform,3"
          ];
          workspace = [
            "1,monitor:DP-1"
            "2,monitor:HDMI-A-1"
            "3,monitor:DP-1"
            "4,monitor:DP-1"
          ];
          device = [
            {
              name = "kb-5.0-keyboard";
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

      # hypridle = enabled;
      clipman = enabled;
      hyprshot = enabled;
      ags = enabled;
      anyrun = enabled;
      rofi = enabled;

      # wbg = enabled' {
      #   wallpaperImg = "~/Wallpapers/saber-dark.png";
      # };
    };
    shell = enabled;
  };

  apps = valueForEach [
    "alacritty" # terminal
    "vivaldi" # browser
    "mpv" # video player
    "neovim" # editor
    "nomacs" # image viewer
    "vesktop" # discord client
    "telegram" # telegram client
    "onlyoffice" # office suit
    "pcmanfm" # file manager
    "gimp"
  ]
    { enable = true; };

  home.packages = with pkgs; [
    obsidian # note taking
    yt-dlp # to download from youtube 
    dnix.pavucontrol-qt # control sound
  ];

  services = {
    udiskie = enabled' {
      tray = "never";
    };
    syncthing = enabled;
  };

  home.stateVersion = "23.11";
}
