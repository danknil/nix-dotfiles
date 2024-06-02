lib:
let
  inherit (lib) mkOption
    foldr unique zipAttrsWith
    all isList concatLists
    isAttrs last;
in
rec {
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt type default null;

  disabled = { enable = false; };

  enabled' = added: { enable = true; } // added;
  enabled = enabled' { };

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

  # FIXME: not working, fix exist?
  getHomeConfig = homeConfigurations:
    { hostname, username ? "" }:
      homeConfigurations."${username}@${hostname}" or homeConfigurations."${username}";

}
