{ lib
, inputs
, pkgs
, ...
}:
let
  inherit (lib) enabled' disabled;
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;

    # blacklist watchdog modules
    extraModprobeConfig = ''
      blacklist iTCO_wdt
      blacklist sp5100_tco
    '';

    # disable watchdog and make boot quiet
    kernelParams = [
      "nowatchdog"
      "quiet"
      "loglevel=3"
      "systemd.show_status=false"
      "rd.udev.log_level=3"
    ];

    kernel.sysctl = {
      # disable kernel messages
      "kernel.printk" = "3 3 3 3";
    };

    initrd = {
      # enable systemd at stage 1
      systemd = enabled' {
        # we dont want to wait-online
        network.wait-online = disabled;
      };
      checkJournalingFS = false;
    };

    loader = {
      timeout = 0;
      # this should be off after installation
      efi.canTouchEfiVariables = false;
      # setting systemd-boot for all setups
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };
}
