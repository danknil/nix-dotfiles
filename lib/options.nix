{mkOption, ...}: rec {
  mkOpt = type: default: description:
    mkOption {inherit type default description;};

  mkOpt' = type: default: mkOpt type default null;

  disabled = {enable = false;};

  enabled' = added: {enable = true;} // added;
  enabled = enabled' {};
}
