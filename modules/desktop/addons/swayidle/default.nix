{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.desktop.addons.swayidle;
in
{
  options.danknil.desktop.addons.swayidle = with types; {
    enable = mkBoolOpt false "Enable swayidle";
    events = mkOpt array [ ] "Events to react to";
    timeouts = mkOpt array [ ] "Timeouts for swayidle";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ swayidle swaylock-effects ];
    danknil.home.extraOptions = {
      fonts.fonts = with pkgs; [
        carlito
      ];

      services.swayidle = {
        inherit (cfg) events timeouts;
        enable = true;
        extraArgs = [ ];
      };

      programs.swaylock.settings = {
        daemonize = true;
        ignore-empty-password = true;
        submit-on-touch = true;
        show-keyboard-layout = true;

        clock = true;

        font = "Carlito";
        font-size = 14;

        indicator-radius = 75;
        indicator-thickness = 5;
        indicator-x-position = 0;
        indicator-y-position = 0;

        inside-color = "000000ff";
        inside-clear-color = "eeee22";
        inside-caps-lock-color = "ff2222";

        screenshots = true;
        effect-blur = "20x5";
        effect-vignette = "0.05:0.2";
      };
    };
  };
}
