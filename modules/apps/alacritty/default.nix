{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.alacritty;
in
{
  options.danknil.apps.alacritty = with types; {
    enable = mkBoolOpt false "Enable alacritty terminal emulator";
  };

  config = {
    environment.systemPackages = with pkgs; [
      alacritty
    ];

    fonts.fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];

    danknil.home.extraOptions = {
      programs.alacritty = {
        enable = true;
        settings = {
          live_config_reload = false;
          window = {
            padding = {
              x = 10;
              y = 10;
            };
            dynamic_padding = true;
            decorations = "none";
            opacity = 0.9;
          };

          scrolling = {
            history = 20000;
            multiplier = 4;
          };
          font = {
            normal = {
              family = "FiraCode Nerd Font Mono";
              style = "Retina";
            };
            bold = {
              style = "Bold";
            };
            italic = {
              style = "Italic";
            };
            bold_italic = {
              style = "Bold Italic";
            };
            size = 11.0;
            builtin_box_drawing = false;
          };
          cursor = {
            style = {
              shape = "Beam";
              blinking = "Off";
            };
            thickness = 0.1;
          };
          mouse = {
            double_click.threshold = 200;
            triple_click.threshold = 300;
            hide_when_typing = true;
          };
        };
      };
    };
  };
}
