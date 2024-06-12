{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "mimeappslist";
  propagatedBuildInputs = [
    (pkgs.python3.withPackages (pythonPackages:
      with pythonPackages; [
        pygobject3
      ]))
  ];
  dontUnpack = true;
  installPhase = "install -Dm755 ${./mimeappslist.py} $out/bin/mimeappslist";
}
