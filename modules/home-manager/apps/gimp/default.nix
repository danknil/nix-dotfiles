{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.dnix; let
  cfg = config.apps.gimp;
in {
  options.apps.gimp = {
    enable = mkEnableOption "gimp";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.dnix.gimp-devel];

    xdg.mimeApps.defaultApplications = valueForEach [
      "image/g3fax"
      "image/x-fits"
      "image/x-gimp-gbr"
      "image/x-gimp-gih"
      "image/x-gimp-pat"
      "image/x-pcx"
      "image/x-psd"
      "image/x-sgi"
      "image/x-tga"
      "image/x-xcf"
      "image/tiff"
      "image/x-psp"
      "application/postscript"
    ] "gimp.desktop";
  };
}
