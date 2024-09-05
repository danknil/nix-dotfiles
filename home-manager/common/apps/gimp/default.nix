{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    # pkgs.custom.gimp-devel
    pkgs.gimp
  ];

  # xdg.mimeApps.defaultApplications = lib.valueForEach [
  #   "image/g3fax"
  #   "image/x-fits"
  #   "image/x-gimp-gbr"
  #   "image/x-gimp-gih"
  #   "image/x-gimp-pat"
  #   "image/x-pcx"
  #   "image/x-psd"
  #   "image/x-sgi"
  #   "image/x-tga"
  #   "image/x-xcf"
  #   "image/tiff"
  #   "image/x-psp"
  #   "application/postscript"
  # ] "gimp.desktop";
}
