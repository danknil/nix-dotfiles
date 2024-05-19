rec {
  nix = import ./nix.nix;
  system = import ./system.nix;
  default = _: {
    imports = [ 
    ];
  };
}
