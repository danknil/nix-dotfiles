{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) enabled' enabled;
  zshEnabled' = add: enabled' {enableZshIntegration = true;} // add;
  zshEnabled = zshEnabled' {};
in {
  home.packages = with pkgs; [
    # bat, because it looks cool
    bat

    # atool
    atool
    gnutar
    gzip
    pbzip2
    plzip
    lzop
    lzip
    zip
    unzip
    rar
    lha
    p7zip

    # other
    nh
    killall
  ];

  programs = {
    zsh = enabled' {
      autosuggestion = enabled;
      syntaxHighlighting = enabled;
      enableVteIntegration = true;
      autocd = true;

      dotDir = ".config/zsh";

      historySubstringSearch = enabled;
      history = {
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        extended = true;
        ignoreDups = true;
        save = 10000;
        share = true;
        size = 10000;
      };

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
        }
      ];
    };

    # shell prompt
    starship = zshEnabled' {
      settings = {
        format = ''
          [┌](bold bright-white)$time at $directory
          [└](bold bright-white)[($nix_shell' )](bold bright-blue)
        '';
        nix_shell = {
          disabled = false;
          format = "[$name](bold blue)";
        };
        time = {
          disabled = false;
          time_format = "%H:%M";
          format = "[$time]($style)";
        };
        git_branch = {
          disabled = false;
          style = "bold green";
          format = "on [$branch(:$remote_branch)]($style)";
        };
      };
    };

    # useful programs in shell
    ripgrep = enabled;
    zoxide = zshEnabled;
    fzf = zshEnabled;
    eza = zshEnabled' {
      icons = true;
      git = true;
    };

    # autosetup development environment
    direnv = zshEnabled' {
      nix-direnv = enabled;
    };
  };
}
