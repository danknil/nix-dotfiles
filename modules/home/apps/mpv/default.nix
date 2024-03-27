{ lib
, pkgs
, config
, ...
}:
let cfg = config.apps.mpv;
in {
  options.apps.mpv = with lib; {
    enable = mkEnableOption "Enable MPV player";
  };
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      package =
        pkgs.wrapMpv
          (pkgs.mpv-unwrapped.override {
            waylandSupport = true;
            x11Support = false;
            cddaSupport = false;
            vulkanSupport = true;
            drmSupport = true;
            archiveSupport = true;
            bluraySupport = true;
            bs2bSupport = false;
            cacaSupport = false;
            cmsSupport = false;
            dvdnavSupport = false;
            dvbinSupport = false;
            jackaudioSupport = true;
            javascriptSupport = true;
            libpngSupport = false;
            openalSupport = false;
            pulseSupport = false;
            pipewireSupport = true;
            rubberbandSupport = false;
            screenSaverSupport = false;
            sdl2Support = true;
            sixelSupport = false;
            speexSupport = false;
            swiftSupport = false;
            theoraSupport = false;
            vaapiSupport = true;
            vapoursynthSupport = false;
            vdpauSupport = true;
            xineramaSupport = false;
            xvSupport = false;
            zimgSupport = false;
          })
          {
            scripts = with pkgs.mpvScripts; [
              uosc
              thumbfast
              sponsorblock-minimal
              mpris
            ];
          };
    };
  };
}
