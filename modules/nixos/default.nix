rec {
  services = import ./services;
  default = _: {
    imports = [ 
      services
    ];
  };
}
