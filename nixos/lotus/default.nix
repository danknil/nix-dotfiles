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

      inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.default

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

  boot.loader.efi.efiSysMountPoint = "/efi";

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
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  # setup fingerprints
  services = {
    open-fprintd = enabled;
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
  };
  powerManagement = enabled' {
    powertop = enabled;
  };
  programs = {
    zsh = enabled;
    direnv = enabled;
    gamemode = enabled;
  };
  system.stateVersion = "23.11";
}
