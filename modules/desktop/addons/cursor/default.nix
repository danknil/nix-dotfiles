{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.desktop.addons.cursor;
in
{
  options.danknil.desktop.addons.cursor = with types; {
    enable = mkBoolOpt false "enable cursor addon";
    package = mkOpt package pkgs.bibata-cursors "Cursor package to use";
    name = mkOpt str "Bibata-Modern-Ice" "Cursor name to use";
    size = mkOpt int 24 "Cursor size to use";
  };

  config = mkIf cfg.enable {
    danknil.home.extraOptions = {
      home.pointerCursor = {
        inherit (cfg) package name size;
        gtk.enable = true;
      };
    };
  };
}
