{ stdenv
, lib
, fetchFromGitLab
, meson
, pkg-config
, ninja
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "dfl-utils";
  version = "dev-2023-27-11";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "utils";
    rev = "dc97a675b79b95b60b9bfb803cb300b1b38e9764";
    hash = "sha256-IxWYxQP9y51XbZAR+VOex/GYZblAWs8KmoaoFvU0rCY=";
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
    homepage = "https://gitlab.com/desktop-frameworks/utils";
    description = "The DesQ library to obtain system information and various classes and functions to be used across the DesQ project. This library provides single-instance Application classes for Core and Gui, advanced file-system watcher, a very simple IPC, functions to return XDG variables, desktop file parsing, and read various system info like battery, network, storage, cpu and RAM info.";
    maintainers = with lib.maintainers; [ danknil ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
