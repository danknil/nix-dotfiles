{ inputs
, lib
, pkgs
, ...
}:
with lib;
with lib.dnix;
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  networking.hostName = "dankbook";
  time.timeZone = "Asia/Novosibirsk";

  services.udisks2 = enabled;
  programs.zsh = enabled;
  programs.hyprland = enabled' {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.danknil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  environment.systemPackages = [ pkgs.tpm2-tss ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "commit=120" ];

  # power management setup
  systemd.sleep.extraConfig = "HibernateDelaySec=1200";
  services = {
    upower = enabled;
    thermald = enabled;
  };
  powerManagement = enabled' {
    powertop = enabled;
  };
  programs.auto-cpufreq = enabled' {
    settings = {
      charger = {
        governor = "schedutil";
        turbo = "auto";
      };

      battery = {
        governor = "schedutil";
        turbo = "off";
        scaling_max_freq = 1500000;
      };
    };
  };

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  # hardware setup
  boot.initrd.kernelModules = [ "i915" ]; # early boot gpu module

  # add vdpau to env
  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  profiles = {
    # users.users = {
    #   danknil = {
    #     isSudo = true;
    #     options = {
    #       hyprland = true;
    #       zsh = true;
    #       udiskie = true;
    #     };
    #   };
    # };
    gaming = enabled' {
      enableMinecraft = true;
    };
    sddm = enabled;
    system = {
      sound = enabled;
      network = enabled' {
        wireless = true;
      };
      bluetooth = true;
      splash = true;
      ssd = true;
      graphics.extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  system.stateVersion = "23.11";
}
