{ lib, ... }:
with lib; rec {
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt' type default null;

  enabled = { enable = true; };
  disabled = { enable = false; };

  recursiveMerge =
    zipAttrsWith (n: values:
      if tail values == [ ]
      then head values
      else if all isList values
      then unique (concatLists values)
      else if all isAttrs values
      then recursiveMerge values
      else last values
    );
}
