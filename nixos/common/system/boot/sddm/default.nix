{ lib
, pkgs
, ...
}:
let
  inherit (lib) enabled' enabled;
in
{
  imports = [ ../splash ];

  environment.systemPackages = [ pkgs.elegant-sddm ];

  services.displayManager.sddm = enabled' {
    package = (pkgs.kdePackages.sddm.override {
      withWayland = true;
    });
    wayland = enabled;
    extraPackages = [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
    theme = "Elegant";
  };

  systemd.services."plymouth-transition" = enabled' {
    # taken from arch wiki https://wiki.archlinux.org/title/Plymouth#Smooth_transition
    unitConfig = {
      Conflicts = "plymouth-quit.service";
      After = "plymouth-quit.service rc-local.service plymouth-start.service systemd-user-sessions.service";
      OnFailure = "plymouth-quit.service";
    };

    serviceConfig = {
      ExecStartPre = "-/usr/bin/plymouth deactivate";
      ExecStartPost = [ "-/usr/bin/sleep 30" "-/usr/bin/plymouth quit --retain-splash" ];
    };
  };
}
