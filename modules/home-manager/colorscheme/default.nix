{ config, lib, inputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
with lib;
with lib.dnix;
{
  options = with types; {
    colorSchemeName = mkOpt str "gruvbox-light-soft" "name for the scheme";
  };

  config = {
    colorscheme = colorSchemes.${config.colorSchemeName};
  };
}
