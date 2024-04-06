# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  environment.variables.EDITOR = "nvim";

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot = {
    kernelParams = [ "initcall_blacklist=acpi_cpufreq_init amd-pstate=active" ];
  };

  services.fstrim = enabled; # enable fstrim for ssd
  services.dbus.implementation = "broker";

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  services.udisks2 = enabled;
  networking = {
    hostName = "dankpc";
    networkmanager = enabled;
    firewall = enabled;
  };

  # Set your time zone.
  time.timeZone = "Asia/Novosibirsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.zsh = enabled;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.danknil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    inconsolata-nerdfont
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
  ];

  # setup opengl
  hardware.opengl = enabled' {
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs.rocmPackages; [
      clr
      clr.icd
    ];
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}

