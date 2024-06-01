{ lib
, stdenv
, callPackage
, kdePackages
, fetchFromGitHub
, cmake
, pkg-config
, json-glib
, libexif
, menu-cache
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "lxqt-archiver";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-archiver";
    rev = version;
    hash = "sha256-32Wq0Faphu0uSG0RdOqrDD/igrNaP6l1mtuV+HcsdcQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    (callPackage ../lxqt-build-tools { })
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    json-glib
    libexif
    (callPackage ../libfm-qt { })
    menu-cache
    kdePackages.qtbase
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-archiver/";
    description = "Archive tool for the LXQt desktop environment";
    mainProgram = "lxqt-archiver";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ jchw ] ++ teams.lxqt.members;
  };
}
