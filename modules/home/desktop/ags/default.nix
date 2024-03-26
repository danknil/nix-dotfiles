{ lib
, pkgs
, config
, ...
}:
let cfg = config.profiles.desktop.ags;
in {
  options.profiles.desktop.ags = with lib; {
    enable = mkEnableOption "Enable ags with notifications and bar";
  };
  config = lib.mkIf cfg.enable {
    programs.ags = {
      enable = true;
      # null or path, leave as null if you don't want hm to manage the config
      configDir = ./config;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
  };
}
