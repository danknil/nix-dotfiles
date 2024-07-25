{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) enabled enabled';
  getApp = name: ../common/apps/${name};
  appList = [
    (getApp "alacritty")
    (getApp "nomacs")
    (getApp "mpv")
    (getApp "firefox")
  ];
in {
  imports =
    [
      ../common/xdg
      ../common/shell/zsh
      ../common/shell/tmux
      ../common/shell/pass
    ]
    ++ appList;
  home = {
    username = "danknil";
    homeDirectory = "/home/danknil";

    sessionVariables = {
      TERM = "xterm-256color";
      TERMINAL = "alacritty";
      NIXOS_OZONE_WL = "1";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
          "\\\${HOME}/.steam/root/compatibilitytools.d";
    };

    packages = with pkgs; [
      # lsp
      nil
      alejandra
      statix
      stylua
      vale
      prettierd
      custom.jdt-language-server
      rust-analyzer
      astyle
      # zed testing
      custom.zed-editor-preview
      # for better coding support
      devenv
      # git client
      lazygit
      # java ide
      jetbrains.idea-community-bin
      # wayland support
      qt6.qtwayland
      libsForQt5.qt5.qtwayland

      neovide # best neovim gui <3

      gpu-screen-recorder # for replays

      wl-clipboard

      vivaldi
      vesktop
      telegram-desktop
      wpsoffice

      # minecraft for life :3
      (pkgs.prismlauncher.override {
        jdks = [jdk8 temurin-bin-11 temurin-bin-17 temurin-bin];
        withWaylandGLFW = true;
      })

      # fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
      (nerdfonts.override {
        fonts = [
          "SourceCodePro"
          "ZedMono"
          "IBMPlexMono"
          "Mononoki"
        ];
      })
    ];

    stateVersion = "23.11";
  };

  stylix = {
    cursor = {
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Rose-Pine-Dawn";
      size = 24;
    };
  };

  programs = {
    home-manager = enabled;
    git = enabled' {
      delta = enabled;
      userEmail = "danknil@protonmail.com";
      userName = "danknil";
    };
  };

  fonts.fontconfig = enabled;
}
