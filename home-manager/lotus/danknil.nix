{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) enabled enabled';
  getApp = name: ../common/apps/${name};
  appList = [
    (getApp "alacritty")
#    (getApp "gimp")
    (getApp "nomacs")
    (getApp "mpv")
  ];
in {
  imports =
    [
      ../common/xdg
      ../common/shell/zsh
    ]
    ++ appList;

  home.username = "danknil";
  home.homeDirectory = "/home/danknil";

  stylix = {
    cursor = {
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Adw-Dark";
      size = 24;
    };
  };

  services = {
    syncthing = enabled;
  };

  home.sessionVariables = {
    TERM = "alacritty";
    TERMINAL = "alacritty";
    NIXOS_OZONE_WL = "1";
  };

  home.packages = with pkgs; [
    # lsp
    nil
    alejandra
    statix
    stylua
    vale
    prettierd
    jdt-language-server
    # for better coding support
    devenv
    # wayland support
    qt6.qtwayland
    libsForQt5.qt5.qtwayland

#    neovide

    gpu-screen-recorder # for replays

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

  programs = {
    home-manager = enabled;
    git = enabled' {
      delta = enabled;
      userEmail = "danknil@protonmail.com";
      userName = "danknil";
    };
  };

  fonts.fontconfig = enabled;

  home.stateVersion = "23.11";
}
