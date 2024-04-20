{ lib, ... }:
with lib; rec {
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt type default null;

  disabled = { enable = false; };

  enabled' = added: { enable = true; } // added;
  enabled = enabled' { };

  ifEnabled = cfg: mkIf cfg.enable;

  toRGB = color: {
    R = builtins.substring 0 2 color;
    G = builtins.substring 2 2 color;
    B = builtins.substring 4 2 color;
  };

  valueForEach = names: value: foldr
    (name: acc: acc // { "${name}" = value; })
    { }
    (unique names);

  recursiveMerge =
    zipAttrsWith (n: values:
      # if list we merge
      if all isList values
      then unique (concatLists values)
      # if attrs we recursing
      else if all isAttrs values
      then recursiveMerge values
      # else return last
      else last values
    );
}
