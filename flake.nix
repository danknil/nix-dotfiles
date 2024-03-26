{
  description = "DankNil main nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    ags.url = "github:Aylur/ags";
    nixd.url = "github:nix-community/nixd";

    # Hypr software, my beloved <3
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hypridle.url = "github:hyprwm/hypridle";
    # TODO: add to packages in hyprshot
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprlock.url = "github:hyprwm/hyprlock";

    # For building my home folder
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:msfjarvis/flake-systems";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Flake builder
    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          namespace = "dnix";
          meta = {
            # Your flake's preferred name in the flake registry.
            name = "danknil-flake";
            # A pretty name for your flake.
            title = "DankNil's Flake System configuration";
          };
        };
      };
    in
    lib.mkFlake {
      channels-config.allowUnfree = true;

      # systems.modules = with inputs; [
      #   home-manager.nixosModules.home-manager
      # ];

      homes.modules = with inputs; [
        hyprland.homeManagerModules.default
        hypridle.homeManagerModules.default
        hyprlock.homeManagerModules.default
        hyprpaper.homeManagerModules.default
        ags.homeManagerModules.default
      ];

      overlays = with inputs; [
        nixd.overlays.default
      ];
    };
}
