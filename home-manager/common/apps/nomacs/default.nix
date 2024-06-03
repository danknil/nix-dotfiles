{ pkgs
, lib
, ...
}:
{
  home.packages = [ pkgs.nomacs ];
  # xdg.mimeApps.defaultApplications = lib.valueForEach [
  #   "image/avif"
  #   "image/bmp"
  #   "image/gif"
  #   "image/heic"
  #   "image/heif"
  #   "image/jpeg"
  #   "image/jxl"
  #   "image/png"
  #   "image/tiff"
  #   "image/webp"
  #   "image/x-eps"
  #   "image/x-ico"
  #   "image/x-portable-bitmap"
  #   "image/x-portable-graymap"
  #   "image/x-portable-pixmap"
  #   "image/x-xbitmap"
  #   "image/x-xpixmap"
  # ] "org.nomacs.ImageLounge.desktop";
}
