{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) disabled enabled enabled' mkDefault;
in {
  environment.systemPackages = with pkgs; [
    # all nixos systems should have this
    git
    wget
  ];
  # better dbus implementation
  services.dbus.implementation = "broker";

  # enabling all firmware because there is no reason i dont want it
  hardware.enableAllFirmware = mkDefault true;

  # **Some optimizations from steam deck**
  boot.kernel.sysctl = {
    # 20-net-timeout.conf
    # This is required due to some games being unable to reuse their TCP ports
    # if they're killed and restarted quickly - the default timeout is too large.
    "net.ipv4.tcp_fin_timeout" = 5;

    # 30-vm.conf
    # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
    # see comment in include/linux/mm.h in the kernel tree.
    "vm.max_map_count" = 2147483642;
  };

  networking = {
    networkmanager = enabled;
    firewall.enable = mkDefault true;
  };

  # enable disk manager
  services.udisks2 = enabled;

  # disable sound because it doesn't work with pipewire
  sound = disabled;

  # setup sound with pipewire
  security.rtkit = enabled;
  services.pipewire = enabled' {
    alsa = enabled;
    pulse = enabled;
    jack = enabled;
  };
}
