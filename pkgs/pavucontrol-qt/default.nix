{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libpulseaudio,
  kdePackages,
  gitUpdater,
  ...
}:
stdenv.mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-dhFVVqJIX40oiHCcnG1166RsllXtfaO7MqM6ZNizjQQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    (callPackage ../lxqt-build-tools {})
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    libpulseaudio
  ];

  passthru.updateScript = gitUpdater {};

  meta = with lib; {
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    mainProgram = "pavucontrol-qt";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = teams.lxqt.members;
  };
}
