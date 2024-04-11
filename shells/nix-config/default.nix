{ lib
, inputs
, pkgs
, stdenv
, ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];
}
