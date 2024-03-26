{ lib
, pkgs
, stdenv
, kdePackages
, meson
, ninja
, pixman
, pkg-config
, json_c
, fetchFromGitLab
, mpv-unwrapped
, wlroots
, wayland
, ...
}:
stdenv.mkDerivation rec {
  pname = "qtgreet";
  version = "dev-2024-03-05";

  outputs = [ "bin" "out" ];

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = "QtGreet";
    rev = "f5d94d4ca20d12df099b54723566f51c48b405d1";
    hash = "sha256-XnfgLH1W7S0KTsyG9BLqyzvOX8K8JDloVOpLu+DAxgk=";
  };

  # patches = [
  #   ./paths.patch
  #   ./xsession.patch
  # ];

  postPatch = ''
    
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    kdePackages.qttools
  ];

  buildInputs = with pkgs.dnix; [
    kdePackages.qtbase
    kdePackages.wayqt
    dfl-login1
    dfl-utils
    dfl-applications
    dfl-ipc
    json_c
    mpv-unwrapped
    wlroots
    wayland
    pixman
  ];

  # enableParallelBuilding = true;

  dontWrapQtApps = true;
  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  meta = with lib; {
    description = "Qt based greeter for greetd, to be run under wayfire or similar wlr-based compositors";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://gitlab.com/marcusbritanicus/QtGreet";
    maintainers = with maintainers; [ danknil ];
  };
}
