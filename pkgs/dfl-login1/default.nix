{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  systemd,
  kdePackages,
}:
stdenv.mkDerivation rec {
  pname = "dfl-login1";
  version = "dev-2024-18-01";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "login1";
    rev = "07a069daf1bf8af58cea220271146e21bea34321";
    hash = "sha256-7URHVc0082LuzteSXAK1nE7vcArrsxaHG1LCV/RvTm4=";
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
    systemd
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  dontWrapQtApps = true;

  outputs = ["out" "dev"];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/login1";
    description = "DFL Login1 class implements a part of the systemd logind dbus protocol.";
    maintainers = with lib.maintainers; [danknil];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
