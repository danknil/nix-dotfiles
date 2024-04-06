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
    # install fonts
    home.packages = with pkgs; [
      ubuntu_font_family
      jetbrains-mono
    ];

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
    profiles.desktop.hyprland.extraConfig = {
      exec-once = [ "ags" ];
    };
  };
}
