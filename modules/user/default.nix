{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.danknil.user;
  # defaultIconFileName = "profile.png";
  # defaultIcon = pkgs.stdenvNoCC.mkDerivation {
  #   name = "default-icon";
  #   src = ./. + "/${defaultIconFileName}";
  #
  #   dontUnpack = true;
  #
  #   installPhase = ''
  #     cp $src $out
  #   '';
  #
  #   passthru = { fileName = defaultIconFileName; };
  # };
  # propagatedIcon = pkgs.runCommandNoCC "propagated-icon"
  #   { passthru = { fileName = cfg.icon.fileName; }; }
  #   ''
  #     local target="$out/share/plusultra-icons/user/${cfg.name}"
  #     mkdir -p "$target"
  #     cp ${cfg.icon} "$target/${cfg.icon.fileName}"
  #   '';
in
{
  options.danknil.user = with types; {
    name = mkOpt str "danknil" "The name to use for the user account.";
    fullName = mkOpt str "Mikhail Balashov" "The full name of the user.";
    email = mkOpt str "danknil@protonmail.com" "The email of the user.";
    initialPassword = mkOpt str "password"
      "The initial password to use when the user is first created.";
    # icon = mkOpt (nullOr package) defaultIcon
    #   "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { }
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      gitFull
      ripgrep
      ripgrep-all
      atool
      fd
    ];

    fonts = {
      fonts = with pkgs; [
        # vegur
        # source-code-pro
        # jetbrains-mono
        # font-awesome
        corefonts
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
      ];
      fontconfig.subpixel.lcdfilter = "default";
      fontconfig.hinting.enable = true;
    };

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      histFile = "$XDG_CACHE_HOME/zsh.history";
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs.mtr.enable = true;

    danknil.home = {
      file = {
        "Desktop/.keep".text = "";
        "Documents/.keep".text = "";
        "Downloads/.keep".text = "";
        "Music/.keep".text = "";
        "Pictures/.keep".text = "";
        "Videos/.keep".text = "";
        "work/.keep".text = "";
        # ".face".source = cfg.icon;
        # "Pictures/${
        #   cfg.icon.fileName or (builtins.baseNameOf cfg.icon)
        # }".source = cfg.icon;
      };

      extraOptions = {
        programs = { 
          fzf = {
            enable = true;
            enableZshIntegration = true;
          };

          starship = {
            enable = true;
            enableZshIntegration = true;
            settings = { };
          };

          zoxide = {
            enable = true;
            enableZshIntegration = true;
          };

          zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;
            enableVteIntegration = true;
            autocd = true;

            dotDir = ".config/zsh";

            historySubstringSearch.enable = true;
            history = {
              # path = "${config.xdg.dataHome}/zsh/zsh_history";
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
          git = {
            enable = true;
            package = pkgs.gitAndTools.gitFull;
            userName = cfg.name;
            userEmail = cfg.email;
            aliases = { };
            delta = {
              enable = true;
            };
          };
        };
      };
    };

    users.users.${cfg.name} = {
      isNormalUser = true;

      inherit (cfg) name initialPassword;

      home = "/home/${cfg.name}";
      group = "users";

      shell = pkgs.zsh;

      # Arbitrary user ID to use for the user. Since I only
      # have a single user on my machines this won't ever collide.
      # However, if you add multiple users you'll need to change this
      # so each user has their own unique uid (or leave it out for the
      # system to select).
      uid = 1000;

      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
