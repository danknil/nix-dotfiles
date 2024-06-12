{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.fonts;
in
  with lib;
  with lib.dnix; {
    options.fonts = with types; {
      nerdfonts = mkOpt' (listOf str) [];
      packages = mkOpt' (listOf package) [];
    };

    config = {
      fonts.fontconfig = enabled;
      home.packages = with pkgs;
        [
          (nerdfonts.override {fonts = cfg.nerdfonts;})
          # discord fonts
          noto-fonts
          noto-fonts-cjk
          noto-fonts-extra
        ]
        ++ cfg.packages;
    };
  }
