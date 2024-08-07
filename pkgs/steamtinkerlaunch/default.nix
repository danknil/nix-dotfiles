{
  bash,
  gawk,
  git,
  gnugrep,
  fetchFromGitHub,
  lib,
  makeWrapper,
  stdenv,
  unixtools,
  unzip,
  wget,
  xdotool,
  xorg,
  yad,
}:
# add steamcompattool output so it can be used in programs.steam.extraCompatPackages
stdenv.mkDerivation rec {
  pname = "steamtinkerlaunch";
  version = "12.12";

  src = fetchFromGitHub {
    owner = "sonic2kk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oigHNfg5rHxRabwUs66ye+chJzivmCIw8mg/GaJLPkg=";
  };

  # hardcode PROGCMD because #150841
  postPatch = ''
    substituteInPlace steamtinkerlaunch --replace 'PROGCMD="''${0##*/}"' 'PROGCMD="steamtinkerlaunch"'
  '';

  outputs = ["out" "steamcompattool"];

  nativeBuildInputs = [makeWrapper];

  installFlags = ["PREFIX=\${out}"];

  postInstall = ''
    wrapProgram $out/bin/steamtinkerlaunch --prefix PATH : ${lib.makeBinPath [
      bash
      gawk
      git
      gnugrep
      unixtools.xxd
      unzip
      wget
      xdotool
      xorg.xprop
      xorg.xrandr
      xorg.xwininfo
      yad
    ]}
    mkdir -p $steamcompattool/SteamTinkerLaunch
    ln -s $out/bin/steamtinkerlaunch $steamcompattool/SteamTinkerLaunch
  '';

  meta = with lib; {
    description = "Linux wrapper tool for use with the Steam client for custom launch options and 3rd party programs";
    mainProgram = "steamtinkerlaunch";
    homepage = "https://github.com/sonic2kk/steamtinkerlaunch";
    license = licenses.gpl3;
    maintainers = with maintainers; [urandom];
    platforms = lib.platforms.linux;
  };
}
