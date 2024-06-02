# danknil's main notebook config
{ lib
, pkgs
, inputs
, outputs
, ...
}:
let
  inherit (lib) enabled enabled' getHomeConfig;
  # get user config
  danknilConfig = getHomeConfig outputs.homeConfigurations {
    hostname = "nymphaea";
    username = "danknil";
  };
in
{
  imports =
    [
      # Home Manager
      inputs.home-manager.nixosModules.home-manager

      # import configuration modules
      outputs.nixosModules.default

      # import common modules
      ../common/nix
      ../common/system/boot
      ../common/system/boot/sddm
      ../common/desktop

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Select internationalisation properties.
  # using this because it closer to russian
  i18n.defaultLocale = "en_DK.UTF-8";
  networking.hostName = "nymphaea";
  time.timeZone = "Asia/Novosibirsk";

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "commit=120" ];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  # early boot gpu module
  boot.initrd.kernelModules = [ "i915" ];

  programs.zsh = enabled;
  users.users.danknil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "corectrl" ];
    shell = pkgs.zsh;
  };
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit lib inputs outputs; };
    users = {
      danknil = ../../home-manager/nymphaea/danknil.nix;
    };
  };

  # enable bluetooth & wifi
  networking.networkmanager.wifi = {
    backend = "iwd";
    powersave = true;
  };
  hardware = {
    bluetooth = enabled' {
      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
    };
  };


  environment = {
    systemPackages = with pkgs; [
      tpm2-tss
      neovim

      gpu-screen-recorder # for replays
      
      # minecraft for life :3
      (pkgs.prismlauncher.override {
        jdks = [ jdk8 temurin-bin-11 temurin-bin-17 temurin-bin ];
        withWaylandGLFW = true;
      })
    ];

    # set EDITOR to neovim
    variables.EDITOR = "nvim";
  };

  programs.gamemode = enabled;
  chaotic = {
    mesa-git = enabled' {
      extraPackages = [ pkgs.mesa_git.opencl ];
    };
  };

  # add vdpau to env
  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

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
  system.stateVersion = "23.11";
}
