{ lib
, config
, ...
}:
with lib;
with lib.dnix;
let cfg = config.apps.alacritty;
in {
  options.apps.alacritty = {
    enable = mkEnableOption "Enable alacritty, GPU-accelerated terminal emulator";
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      TERM = "alacritty";
    };
    fonts.nerdfonts = [
      "SourceCodePro"
      # TODO: test this fonts
      # "ZedMono"
      # "IBMPlexMono"
      # "Mononoki"
    ];
    programs.alacritty = {
      enable = true;
      # TODO: extra settings
      settings = {
        live_config_reload = false;
        window = {
          padding = { x = 20; y = 20; };
          decorations = "None";
          opacity = 0.8;
          dynamic_title = false;
          dynamic_padding = true;
        };
        font = {
          normal = { family = "SauceCodePro Nerd Font Mono"; style = "Regular"; };
          size = 16;
        };
        cursor = {
          style = "Underline";
          thickness = 0.2;
        };
        mouse = {
          hide_when_typing = true;
        };
        # coloring example from https://github.com/aarowill/base16-alacritty/blob/master/templates/default-256.mustache
        colors = with config.colorscheme.palette; {
          draw_bold_text_with_bright_colors = false;
          primary = {
            background = "#${base00}";
            foreground = "#${base05}";
          };
          cursor = {
            text = "#${base00}";
            cursor = "#${base05}";
          };
          normal = {
            black = "#${base00}";
            red = "#${base08}";
            green = "#${base0B}";
            yellow = "#${base0A}";
            blue = "#${base0D}";
            magenta = "#${base0E}";
            cyan = "#${base0C}";
            white = "#${base05}";
          };
          bright = {
            black = "#${base03}";
            red = "#${base09}";
            green = "#${base01}";
            yellow = "#${base02}";
            blue = "#${base04}";
            magenta = "#${base06}";
            cyan = "#${base0F}";
            white = "#${base07}";
          };
        };
        # colors = {
        #   primary = {
        #     background = "#fbf1c7";
        #     foreground = "#3c3836";
        #   };
        #   normal = {
        #     black = "#fbf1c7";
        #     red = "#cc241d";
        #     green = "#98971a";
        #     yellow = "#d79921";
        #     blue = "#458588";
        #     magenta = "#b16286";
        #     cyan = "#689d6a";
        #     white = "#7c6f64";
        #   };
        #   bright = {
        #     black = "#928374";
        #     red = "#9d0006";
        #     green = "#79740e";
        #     yellow = "#b57614";
        #     blue = "#076678";
        #     magenta = "#8f3f71";
        #     cyan = "#427b58";
        #     white = "#3c3836";
        #   };
        # };
      };
    };
  };
}
