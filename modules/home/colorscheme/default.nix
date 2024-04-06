{ config, lib, inputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  options = with lib; {
    colorSchemeName = dnix.mkOpt types.str "gruvbox-light-hard" "name for the scheme";
  };

  config = {
    colorscheme = colorSchemes.${config.colorSchemeName};
  };
}
