{ stdenv
, lib
, fetchFromGitLab
, meson
, pkg-config
, ninja
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "dfl-ipc";
  version = "dev-2024-15-01";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "ipc";
    rev = "a32ea31a4a84d45993e1ffe89dfd38950919fbb5";
    hash = "sha256-2DTicTRCtVIigsMiyOduHOSmXHVqJ25239ImyEMLuJk=";
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

  buildInputs = [
    kdePackages.qtbase
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  dontWrapQtApps = true;

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/login1";
    description = "DFL Login1 class implements a part of the systemd logind dbus protocol.";
    maintainers = with lib.maintainers; [ danknil ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
