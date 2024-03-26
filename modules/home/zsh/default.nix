{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.profiles.zsh;
in
{
  options.profiles.zsh = with lib; {
    enable = mkEnableOption "Enable zsh";
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      autocd = true;

      dotDir = ".config/zsh";

      historySubstringSearch.enable = true;
      history = {
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        extended = true;
        ignoreDups = true;
        save = 10000;
        share = true;
        size = 10000;
      };

      plugins = [{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.4.0";
          sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
        };
      }];
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = { };
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
