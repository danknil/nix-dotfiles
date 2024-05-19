{ lib
, pkgs
, config
, ...
}:
with lib;
with lib.dnix;
let
  cfg = config.apps.pcmanfm;
in
{
  options.apps.pcmanfm = {
    enable = mkEnableOption "pcmanfm";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dnix.pcmanfm-qt
      # archiver
      dnix.lxqt-archiver
      # ensure all archivers installed
      gnutar
      gzip
      pbzip2
      plzip
      lzop
      lzip
      zip
      unzip
      rar
      lha
      p7zip
    ];

    xdg.mimeApps.defaultApplications = {
     "inode/directory" = "pcmanfm-qt.desktop";
    };
  };
}
