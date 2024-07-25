{lib, ...}: let
  inherit (lib) enabled enabled';
in {
  programs.firefox = enabled' {
    languagePacks = [ "en_US" "ru_RU" ];
  };
}
