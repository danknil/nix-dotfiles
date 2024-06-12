{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) enabled;
in {
  imports = [
    # use sddm as default
    ../../system/boot/sddm
  ];

  # setup plasma
  services.desktopManager.plasma6 = enabled;
  environment.plasma6.excludePackages = with pkgs; [];

  # set plasma as default session
  services.displayManager.defaultSession = "plasma";
}
