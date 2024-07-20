{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) enabled' enabled;
  bg = config.lib.stylix.colors.withHashtag.base00;
  fg = config.lib.stylix.colors.withHashtag.base05;
in {
  home.packages = with pkgs; [
    (writeScriptBin "mux" ''
      result="$(tmuxinator list --newline | tail +2 | fzf --exit-0 --tmux)" &&
      tmuxinator start $result
    '')
    (writeScriptBin "tmux-skill" ''
      session=$(tmux list-sessions -F "#{session_name}" |\
        fzf --query="$1" --select-1 --exit-0 --tmux) &&
        tmux kill-session -t "$session"
    '')
    (writeScriptBin "tmux-ssel" ''
      session=$(tmux list-sessions -F "#{session_name}" |\
        fzf --query="$1" --select-1 --exit-0 --tmux) &&
        tmux switch-client -t "$session"
    '')
  ];
  programs.tmux = enabled' {
    terminal = "tmux-256color";

    sensibleOnTop = true;
    prefix = "C-s";
    mouse = true;
    baseIndex = 1;

    tmuxinator = enabled;

    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind-key N run-shell mux
      bind-key S run-shell tmux-ssel
      bind-key K run-shell tmux-skill

      set -g main-pane-width "88%"
      set -g main-pane-height "88%"

      set -g status-position "top"
      set -g status-style bg=default,fg=default
      set -g status-justify "centre"
      set -g status-left "#[bg=${bg},fg=${fg},bold]#{?client_prefix,, tmux }#[bg=${fg},fg=${bg},bold]#{?client_prefix, tmux ,}#[bg=default,fg=default,bold]"
      set -g status-right " #S "
      set -g window-status-format "#[bg=${bg},fg=${fg}] #I:#W "
      set -g window-status-current-format "#[bg=${fg},fg=${bg}] #I:#W#{?window_zoomed_flag, 󰊓 , }"
    '';
  };
}
