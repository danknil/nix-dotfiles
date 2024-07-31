{lib, ...}: let
  inherit (lib) enabled';
in {
  programs.firefox =
    enabled' {
    };
}
