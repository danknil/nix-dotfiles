{
  lib,
  callPackage,
  ...
}: let
  mergePackages = lib.fold (pkg: acc: {${pkg} = callPackage ./${pkg} {};} // acc) {};
in
  mergePackages [
    "gimp-devel"
    "libfm-qt"
    "lxqt-archiver"
    "lxqt-build-tools"
    "lxqt-menu-data"
    "mimeappslist"
    "mons"
    "pavucontrol-qt"
    "pcmanfm-qt"
    "steamtinkerlaunch"
  ]
