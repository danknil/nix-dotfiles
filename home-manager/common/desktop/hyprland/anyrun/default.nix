{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) enabled';
in {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

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
      * {
        all: unset;
        font-family: "JetBrains Mono Nerd Font", sans-serif;
        font-size: 20px;
        color: #${base05};
      }

      window {
        margin: 10px;
      }

      entry,
      match,
      plugin {
        background-color: #${base00};
      }

      entry {
        padding: 10px;
        margin: 20px;
        border: 5px solid #${base05};
      }
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
}
