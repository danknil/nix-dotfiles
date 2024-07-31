{
  lib,
  inputs,
  pkgs,
  ...
}: {
  default = inputs.devenv.lib.mkShell {
    inherit inputs pkgs;
    modules = [
      ({
        pkgs,
        config,
        ...
      }: {
        packages = [pkgs.git];
        languages.nix.enable = true;
        pre-commit.hooks.alejandra = {
          enable = true;
          fail_fast = true;
        };
      })
    ];
  };
}
