{
  lib,
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: let
  inherit (lib) filterAttrs isType mapAttrs mapAttrsToList mkForce;
  inherit (outputs) overlays;

  flakeInputs = filterAttrs (_: isType "flake") inputs;
in {
  imports = [
    inputs.chaotic.nixosModules.default
  ];

  chaotic.nyx.overlay.enable = mkForce false;

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = true;
  };

  nix = {
    package = pkgs.nixVersions.nix_2_21;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
      persistent = true;
    };
    optimise.automatic = true;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    extraOptions = ''
      keep-outputs = true
      warn-dirty = false
      keep-derivations = true
      use-xdg-base-directories = true
    '';
    settings = {
      accept-flake-config = true;
      nix-path = config.nix.nixPath;
      allowed-users = ["@wheel"];
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
      trusted-users = ["root" "@wheel"];
      use-cgroups = true;
      warn-dirty = false;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
  nixpkgs = {
    overlays = with overlays; [
      additions
      modifications
      stable-packages
      inputs.chaotic.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
}
