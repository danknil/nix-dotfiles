{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.tools.rust;
in
{
  # TODO: add rust toolchain
  options.danknil.tools.rust = with types; {
    enableStable = mkBoolOpt false "Enable stable Rust toolchain for development";
    enableNightly = mkBoolOpt false "Enable nightly Rust toolchain for development";
    enableLsp = mkBoolOpt (cfg.enableNightly || cfg.enableStable) "Enable rust-analyzer for lsp support";
  };

  config = {
  };
}
