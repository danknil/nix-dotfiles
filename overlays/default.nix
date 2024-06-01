# This file defines overlays
{ inputs
, lib
, ...
}:
let
  inherit (lib) mkMerge forEach;
  listOverlays = overlays: final: prev: mkMerge (forEach overlays (overlay:
    {
      "${overlay}" = import "./${overlay}.nix" { inherit lib inputs final prev; };
    }
  ));
in
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: {
    custom = import ../pkgs final.pkgs;
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = listOverlays [ ];
}
