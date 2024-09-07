# danknil's main notebook config
{
  lib,
  pkgs,
  inputs,
  outputs,
  config,
  ...
}: let
  inherit (lib) enabled enabled';
  hardwareSetup = with inputs.nixos-hardware.nixosModules; [
    lenovo-thinkpad-x1-6th-gen
  ];
in {
  imports =
    [
      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      # NixOS styling
      inputs.stylix.nixosModules.stylix
      # auto-cpufreq
      inputs.auto-cpufreq.nixosModules.default

      # fingerprint driver
      inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.default
      # secure boot
      inputs.lanzaboote.nixosModules.lanzaboote

      # import configuration modules
      outputs.nixosModules.default

      # import common modules
      ../common/nix
      ../common/system/boot
      ../common/desktop
      ../common/desktop/kde

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ]
    ++ hardwareSetup;

  networking.hostName = "lotus";
  # using this because it closer to russian
  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Asia/Novosibirsk";

  boot.loader = {
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = lib.mkForce false;
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://i.imgur.com/tqLFc8y.jpeg";
      hash = "sha256-tNv5r5MVpo4Tc0IgwjwPau1pEmTg0WOPT7l1qjWBCqI=";
    };
    base16Scheme = "${inputs.schemes}/base16/tokyo-night-terminal-light.yaml";
    override = {
      base00 = "ECEDF3";
    };
  };

  fileSystems."/".options = ["noatime" "nodiratime" "discard" "commit=240"];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  users.users.danknil = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "corectrl"];
    shell = pkgs.zsh;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit lib inputs outputs;};
    users = {
      danknil = ../../home-manager/lotus/danknil.nix;
    };
  };

  # Start the driver at boot
  # systemd.services.fprintd = {
  #   wantedBy = ["multi-user.target"];
  #   serviceConfig.Type = "simple";
  # };

  # setup fingerprints
  services = {
    python-validity = enabled;
  };

  # setup bios updates
  services.fwupd = enabled;

  # enable bluetooth & wifi
  networking.networkmanager.wifi = {
    backend = "iwd";
    powersave = true;
  };
  hardware.bluetooth = enabled' {
    powerOnBoot = true;
  };

  environment = {
    systemPackages = with pkgs; [
      tpm2-tss
      sbctl
      neovim
    ];

    # set EDITOR to neovim
    variables.EDITOR = "nvim";
  };

  # hardware setup
  chaotic = {
    mesa-git = enabled' {
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        intel-media-driver
      ];
      extraPackages32 = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  # power management setup
  systemd.sleep.extraConfig = "HibernateDelaySec=1200";
  services = {
    upower = enabled;
    thermald = enabled;
    throttled = enabled' {
      extraConfig = ''
        [GENERAL]
        Enabled: True
        Sysfs_Power_Path: /sys/class/power_supply/AC*/online
        Autoreload: False

        [BATTERY]
        Update_Rate_s: 30
        PL1_Tdp_W: 20
        PL1_Duration_s: 28
        PL2_Tdp_W: 39
        PL2_Duration_S: 0.002
        Trip_Temp_C: 85
        cTDP: 0
        Disable_BDPROCHOT: False

        [AC]
        Update_Rate_s: 5
        PL1_Tdp_W: 44
        PL1_Duration_s: 28
        PL2_Tdp_W: 44
        PL2_Duration_S: 0.002
        Trip_Temp_C: 95
        cTDP: 0
        Disable_BDPROCHOT: False

        [UNDERVOLT.BATTERY]
        CORE: -100
        GPU: -80
        CACHE: -100
        UNCORE: -80
        ANALOGIO: 0

        [UNDERVOLT.AC]
        CORE: -100
        GPU: -80
        CACHE: -100
        UNCORE: -80
        ANALOGIO: 0
      '';
    };
  };
  powerManagement = enabled' {
    powertop = enabled;
  };
  programs = {
    zsh = enabled;
    direnv = enabled;
    gamemode = enabled;
    auto-cpufreq = enabled' {
      settings = {
        charger = {
          governor = "schedutil";
          turbo = "auto";
        };

        battery = {
          governor = "schedutil";
          turbo = "auto";
          scaling_max_freq = 2200000;
        };
      };
    };
  };
  system.stateVersion = "23.11";
}
