{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  cfg = config.profiles.desktop.anyrun;
in {
  config = mkIf cfg.enable {
    # profiles.desktop.hyprland.extraConfig.bind = [
    #   "$mainMod, R, exec, rofi -show drun"
    # ];
    programs.anyrun = enabled' {
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          kidex
          translate
          symbols
          rink
          shell
        ];
        x = {fraction = 0.5;};
        y = {fraction = 0.05;};
        width = {fraction = 0.3;};
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
      };
      extraCss = with config.lib.stylix.colors; ''

      '';

      extraConfigFiles = {
        "applications.ron".text = ''
          Config(
            // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
            desktop_actions: true,
            max_entries: 5,
            // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
            // to determine what terminal to use.
            terminal: Some("alacritty"),
          )
        '';
        "dictionary.ron".text = ''
          Config(
            prefix: ":def",
            max_entries: 3,
          )
        '';
        "kidex.ron".text = ''
          Config(
            max_entries: 5,
          )
        '';
        "shell.ron".text = ''
          Config(
            prefix: ":sh",
            // Override the shell used to launch the command
            shell: None,
          )
        '';
        "symbols.ron".text = ''
          Config(
            // The prefix that the search needs to begin with to yield symbol results
            prefix: ":sym",
            // Custom user defined symbols to be included along the unicode symbols
            symbols: {
              // "name": "text to be copied"
              "shrug": "¯\\_(ツ)_/¯",
            },
            max_entries: 3,
          )
        '';
      };
    };
  };
}
