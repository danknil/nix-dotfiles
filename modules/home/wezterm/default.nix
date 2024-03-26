{ lib
, pkgs
, config
, ...
}:
let cfg = config.profiles.wezterm;
in {
  options.profiles.wezterm = with lib; {
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
