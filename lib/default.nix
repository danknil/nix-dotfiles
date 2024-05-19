_:
{ mkMerge
, forEach
, ...
}@prev:
let
  mergeLibs = libs: mkMerge (forEach libs (name: (import ./${name}.nix prev)));
in
mergeLibs [
  "options"
  "utils"
]
