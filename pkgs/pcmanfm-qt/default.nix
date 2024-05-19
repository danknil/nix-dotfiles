{ lib
, pkgs
, dnix
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, kdePackages
, libexif
  # , lxqt-build-tools
  # , lxqt-menu-data
, menu-cache
, gitUpdater
, ...
}:

stdenv.mkDerivation rec {
  pname = "pcmanfm-qt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-PyCtcn+QHwX/iy85A3y7Phf8ogdSRrwtXrJYGxrjyLM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    pkgs.dnix.lxqt-build-tools
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    libexif
    pkgs.dnix.lxqt-menu-data
    kdePackages.qtbase
    kdePackages.qtimageformats # add-on module to support more image file formats
    dnix.libfm-qt
    menu-cache
  ];

  passthru.updateScript = gitUpdater { };

  postPatch = ''
    substituteInPlace config/pcmanfm-qt/lxqt/settings.conf.in --replace-fail @LXQT_SHARE_DIR@ /run/current-system/sw/share/lxqt
  '';

  meta = with lib; {
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    mainProgram = "pcmanfm-qt";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
