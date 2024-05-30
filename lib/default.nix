lib: rec {
  mkOpt = type: default: description:
    lib.mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt type default null;

  disabled = { enable = false; };

  enabled' = added: { enable = true; } // added;
  enabled = enabled' { };

  toRGB = color: {
    R = builtins.substring 0 2 color;
    G = builtins.substring 2 2 color;
    B = builtins.substring 4 2 color;
  };

  valueForEach = names: value: lib.foldr
    (name: acc: acc // { "${name}" = value; })
    { }
    (lib.unique names);

  recursiveMerge =
    lib.zipAttrsWith (n: values:
      # if list we merge
      if lib.all lib.isList values
      then lib.unique (lib.concatLists values)
      # if attrs we recursing
      else if lib.all lib.isAttrs values
      then recursiveMerge values
      # else return last
      else lib.last values
    );
}
