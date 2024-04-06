{ lib, pkgs, ... }:
with lib;
with lib.dnix;
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  environment.variables.EDITOR = "nvim";
  services.upower.enable = true;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  powerManagement = enabled;
  systemd.sleep.extraConfig = "HibernateDelaySec=1200";
  services.thermald = enabled;
  services.tlp = enabled' {
    # TODO: settings
    settings = { };
  };

  services.dbus.implementation = "broker";

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  services.udisks2 = enabled;
  networking = {
    hostName = "dankbook";
    networkmanager = enabled' {
      wifi.backend = "iwd";
    };
    firewall = disabled;
  };

  # hardware setup

  boot.initrd.kernelModules = [ "i915" ]; # early boot gpu module

  services.fstrim = enabled; # enable fstrim for ssd

  # add vdpau to env
  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  # setup opengl
  hardware.opengl = enabled' {
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Novosibirsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh = enabled;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.danknil = {
    isNormalUser = true;
    # fullName = "Mikhail Balashov";
    # email = "danknil@protonmail.com";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # Enable CUPS to print documents.
  # services.printing = enabled' {
  #   drivers = with pkgs; [ hplipWithPlugin ];
  # };
  # services.avahi = enabled' {
  #   nssmdns4 = true;
  #   # for a WiFi printer
  #   openFirewall = true;
  # };

  fonts.packages = with pkgs; [
    inconsolata-nerdfont
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    tpm2-tss
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
