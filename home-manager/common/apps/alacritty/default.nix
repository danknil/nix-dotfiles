{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
  tmux = "${pkgs.tmux}/bin/tmux";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = false;
      env = {
        TERM = "xterm-256color";
      };
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "-l"
          "-c"
          "${tmux} attach || ${tmux}"
        ];
      };
      window = {
        padding = {
          x = 20;
          y = 20;
        };
        dynamic_title = false;
        dynamic_padding = true;
      };
      font = {
        size = mkForce 14;
      };
      cursor = {
        style = "Underline";
        thickness = 0.2;
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
