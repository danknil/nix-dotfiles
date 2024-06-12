{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.wezterm;
in {
  options.apps.wezterm = with lib; {
    enable = mkEnableOption "Enable wezterm terminal emulator";
  };
  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm;
      # TODO: add config
      extraConfig = '''';
    };
  };
}
