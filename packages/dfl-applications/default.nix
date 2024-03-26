{ stdenv
, lib
, pkgs
, fetchFromGitLab
, meson
, pkg-config
, ninja
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "dfl-applications";
  version = "dev-2024-08-01";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "applications";
    rev = "19291975c84a65a6abaf23ff8a7dd50239e6cde5";
    hash = "sha256-Q5xt9M4VoJpd756GiHfbto73y3OuDCjdDSdfCK0mzEk=";
  };

  # patches = [
  #   # qmake get qtbase's path, but wayqt need qtwayland
  #   (substituteAll {
  #     src = ./fix-qtwayland-header-path.diff;
  #     qtWaylandPath = "${qtwayland}/include";
  #   })
  # ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    kdePackages.qttools
  ];

  buildInputs = with pkgs.dnix; [
    kdePackages.qtbase
    dfl-ipc
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  dontWrapQtApps = true;

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/applications";
    description = "This library provides a thin wrapper around QApplication, QGuiApplication and QCoreApplication, to provide single-instance functionality.";
    maintainers = with lib.maintainers; [ danknil ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
