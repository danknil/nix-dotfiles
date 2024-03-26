{ lib
, config
, ...
}:
let cfg = config.profiles.alacritty;
in {
  options.profiles.alacritty = with lib; {
    enable = mkEnableOption "Enable alacritty, GPU-accelerated terminal emulator";
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      TERM = "alacritty";
    };
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
          normal = { family = "Inconsolata Nerd Font Mono"; style = "Regular"; };
          size = 16;
        };
        cursor = {
          style = "Underline";
          thickness = 0.2;
        };
        mouse = {
          hide_when_typing = true;
        };
        colors = {
          primary = {
            background = "#fbf1c7";
            foreground = "#3c3836";
          };
          normal = {
            black = "#fbf1c7";
            red = "#cc241d";
            green = "#98971a";
            yellow = "#d79921";
            blue = "#458588";
            magenta = "#b16286";
            cyan = "#689d6a";
            white = "#7c6f64";
          };
          bright = {
            black = "#928374";
            red = "#9d0006";
            green = "#79740e";
            yellow = "#b57614";
            blue = "#076678";
            magenta = "#8f3f71";
            cyan = "#427b58";
            white = "#3c3836";
          };
        };
      };
    };
  };
}
