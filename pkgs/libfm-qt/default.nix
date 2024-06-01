{ lib
, stdenv
, fetchFromGitHub
, cmake
, xorg
, libexif
, libfm
, callPackage
, kdePackages
, menu-cache
, pcre
, pkg-config
, gitUpdater
, version ? "2.0.0"
, ...
}:

stdenv.mkDerivation rec {
  pname = "libfm-qt";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    hash = {
      "1.4.0" = "sha256-QxPYSA7537K+/dRTxIYyg+Q/kj75rZOdzlUsmSdQcn4=";
      "2.0.0" = "sha256-vWkuPdG5KaT6KMr1NJGt7JBUd1z3wROKY79otsrRsuI=";
    }."${version}";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    (callPackage ../lxqt-build-tools { })
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    xorg.libXdmcp
    libexif
    libfm
    xorg.libpthreadstubs
    xorg.libxcb
    (callPackage ../lxqt-menu-data { })
    menu-cache
    pcre
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/libfm-qt";
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
