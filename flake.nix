{
  description = "DankNil main nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nur.url = "github:nix-community/NUR";
    ags.url = "github:Aylur/ags";
    # Hypr software, my beloved <3
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hypridle.url = "github:hyprwm/hypridle";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprlock.url = "github:hyprwm/hyprlock";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    # bleeding edge packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # for my laptop <3
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For building my home folder
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System list
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , systems
    , ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs (import systems);

      lib = nixpkgs.lib.extend
        (final: prev: (import ./lib final) // home-manager.lib);
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit lib inputs; };

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # danknil's notebook
        nymphaea = lib.nixosSystem {
          specialArgs = { inherit lib inputs outputs; };
          modules = [ ./systems/nymphaea ];
        };
        # danknil's pc
        dianthus = lib.nixosSystem {
          specialArgs = { inherit lib inputs outputs; };
          modules = [ ./systems/dianthus ];
        };
      };

      # # Standalone home-manager configuration entrypoint
      # # Available through 'home-manager --flake .#your-username@your-hostname'
      # homeConfigurations = {
      #   # FIXME replace with your username@hostname
      #   "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      #     extraSpecialArgs = { inherit inputs outputs; };
      #     modules = [
      #       # > Our main home-manager configuration file <
      #       ./home-manager/home.nix
      #     ];
      #   };
      # };
    };
  # lib.mkFlake {
  #
  #   channels-config.allowUnfree = true;
  #
  #   systems.modules.nixos = with inputs; [
  #     chaotic.nixosModules.default
  #     {
  #       # manually import overlay
  #       chaotic.nyx.overlay.enable = false;
  #     }
  #
  #     auto-cpufreq.nixosModules.default
  #   ];
  #
  #   homes.modules = with inputs; [
  #     hyprland.homeManagerModules.default
  #     hypridle.homeManagerModules.default
  #     hyprlock.homeManagerModules.default
  #     hyprpaper.homeManagerModules.default
  #     ags.homeManagerModules.default
  #     nix-colors.homeManagerModules.default
  #     nixvim.homeManagerModules.nixvim
  #     anyrun.homeManagerModules.default
  #   ];
  #
  #   overlays = with inputs; [
  #     xdph.overlays.default
  #     chaotic.overlays.default
  #   ];
  #
  #   alias.shells = {
  #     default = "nix-config";
  #   };
  # };
}
