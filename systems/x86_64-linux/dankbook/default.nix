{ lib, pkgs, ... }:
with lib;
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  environment.variables.EDITOR = "nvim";

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # boot = {
  #   initrd.systemd.enable = true;
  #   loader = {
  #     efi.canTouchEfiVariables = true;
  #     timeout = 0;
  #     systemd-boot = {
  #       enable = true;
  #       editor = false;
  #     };
  #   };
  # };

  networking = {
    hostName = "dankbook";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    firewall.enable = false;
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

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.danknil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      qutebrowser
      neovim
      foot
      bemenu
      git
      tree
      clifm
      fzf
      gnumake
      gcc
      nil
      nixd
      wl-clipboard
      nixpkgs-fmt
      ripgrep
      foot
    ];
  };

  programs.sway.enable = true;
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # for a WiFi printer
    openFirewall = true;
  };

  fonts.packages = with pkgs; [
    inconsolata-nerdfont
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    tpm2-tss
  ];

  # user = {
  #   name = "danknil";
  #   fullName = "Mikhail Balashov";
  #   email = "danknil@protonmail.com";
  #   extraGroups = [ "networkmanager" "libvirtd" ];
  # };

  #hardware.audio.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  system.stateVersion = "23.11"; # Did you read the comment?
}
