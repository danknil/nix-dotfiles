{
  lib,
  config,
  ...
}:
with lib;
with lib.dnix; let
  cfg = config.apps.alacritty;
in {
  options.apps.alacritty = {
    enable = mkEnableOption "Enable alacritty, GPU-accelerated terminal emulator";
  };
  config =
    lib.mkIf cfg.enable {
    };
}
