{ lib
, config
, outputs
, inputs
, ...
}: {
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };
  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
        persistent = true;
      };
      optimise.automatic = true;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      extraOptions = ''
        keep-outputs = true
        warn-dirty = false
        keep-derivations = true
        use-xdg-base-directories = true
      '';
      settings = {
        accept-flake-config = true;
        nix-path = config.nix.nixPath;
        allowed-users = [ "@wheel" ];
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        builders-use-substitutes = true;
        experimental-features = [
          "auto-allocate-uids"
          "ca-derivations"
          "cgroups"
          "flakes"
          "nix-command"
          "recursive-nix"
        ];
        flake-registry = "/etc/nix/registry.json";
        http-connections = 50;
        keep-going = true;
        log-lines = 20;
        max-jobs = "auto";
        sandbox = true;
        trusted-users = [ "root" "@wheel" ];
        use-cgroups = true;
        warn-dirty = false;
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    };
  nixpkgs = {
    # You can add overlays here
    overlays = with outputs.overlays; [
      lib
      additions
      modifications
      unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };
}
