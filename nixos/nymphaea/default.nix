# danknil's main notebook config
{ lib
, pkgs
, inputs
, outputs
, config
, ...
}:
let
  inherit (lib) enabled enabled';
  hardwareSetup = with inputs.nixos-hardware.nixosModules; [
    common-pc-ssd
    common-cpu-intel
  ];
in
{
  imports =
    [
      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      # NixOS styling
      inputs.stylix.nixosModules.stylix
      # auto-cpufreq
      inputs.auto-cpufreq.nixosModules.default

      # import configuration modules
      outputs.nixosModules.default

      # import common modules
      ../common/nix
      ../common/system/boot
      ../common/desktop
      ../common/desktop/kde

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ] ++ hardwareSetup;

  networking.hostName = "nymphaea";
  # using this because it closer to russian
  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Asia/Novosibirsk";

  # system theming
  stylix = {
    polarity = "light";
    image = pkgs.fetchurl {
      url = "https://i.imgur.com/tqLFc8y.jpeg";
      hash = "sha256-tNv5r5MVpo4Tc0IgwjwPau1pEmTg0WOPT7l1qjWBCqI=";
    };
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "commit=240" ];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

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
  hardware.bluetooth = enabled' {
    powerOnBoot = true;
    input.General.ClassicBondedOnly = false;
  };

  environment = {
    systemPackages = with pkgs; [
      tpm2-tss
      neovim
    ];

    # set EDITOR to neovim
    variables.EDITOR = "nvim";
  };

  programs.gamemode = enabled;

  # hardware setup
  hardware = {
    opengl = enabled;
    intelgpu.driver =
      if lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8"
      then "xe"
      else "i915";
  };
  chaotic = {
    mesa-git = enabled' {
      extraPackages = config.hardware.opengl.extraPackages;
      extraPackages32 = config.hardware.opengl.extraPackages32;
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
  programs.auto-cpufreq = enabled' {
    settings = {
      charger = {
        governor = "schedutil";
        turbo = "auto";
      };

      battery = {
        governor = "schedutil";
        turbo = "off";
        scaling_max_freq = 1300000;
      };
    };
  };
  system.stateVersion = "23.11";
}
