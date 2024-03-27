{ lib
, pkgs
, stdenv
, python312Packages
, ...
}:
with python312Packages;
buildPythonApplication {
  pname = "mimeappslist";
  version = "1.0";

  outputs = [ "bin" ];

  src = ./.;
  propagatedBuildInputs = [ pygobject3 ];

  meta = with lib; {
    description = "app for checking list of mimeapps";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danknil ];
  };
}
