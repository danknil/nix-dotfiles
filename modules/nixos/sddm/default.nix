{ lib
, config
, pkgs
, ...
}:
with lib;
with lib.dnix;
let cfg = config.profiles.sddm;
in
{
  options.profiles.sddm = {
    enable = mkEnableOption "SDDM";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (elegant-sddm.override {
        themeConfig.General = {
          background = "${./saber-dark.png}";
        };
      })
    ];
    services.displayManager.sddm = enabled' {
      package = (pkgs.libsForQt5.sddm.override {
        withWayland = true;
      });
      wayland = enabled;
      extraPackages = [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
      theme = "Elegant";
    };
  };
}
