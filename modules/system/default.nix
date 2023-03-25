{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.system;
in
{
  options.danknil.system = with types; {
    enable = mkBoolOpt true "Enable managing nix configuration";
    package = mkOpt package pkgs.nix "Which nix package to use.";
  };

  config =
    mkIf cfg.enable {
      # programs.nix-ld.enable = true;
      nix =
        let users = [ "root" config.danknil.user.name ];
        in
        {
          package = cfg.package;
          extraOptions = lib.concatStringsSep "\n" [
            ''
              experimental-features = nix-command flakes
              http-connections = 50
              warn-dirty = false
              log-lines = 50
              sandbox = relaxed
            ''
          ];

          settings = {
            experimental-features = "nix-command flakes";
            http-connections = 50;
            warn-dirty = false;
            log-lines = 50;
            sandbox = "relaxed";
            auto-optimise-store = true;
            trusted-users = users;
            allowed-users = users;
            substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
          };

          gc = {
            automatic = true;
            dates = "weekly";
            # options = "--delete-older-than 30d";
          };

          # flake-utils-plus
          generateRegistryFromInputs = true;
          generateNixPathFromInputs = true;
          linkInputs = true;
        };
    };
}
