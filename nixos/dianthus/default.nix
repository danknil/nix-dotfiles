# danknil's main pc config
{
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: let
  inherit (lib) enabled enabled';
  hardwareSetup = with inputs.nixos-hardware.nixosModules; [
    common-pc-ssd
    common-cpu-amd
    common-gpu-amd
  ];
in {
  imports =
    [
      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      # NixOS styling
      inputs.stylix.nixosModules.stylix

      # import configuration modules
      outputs.nixosModules.default

      # import common modules
      ../common/nix
      ../common/system/boot
      ../common/desktop
      ../common/desktop/kde
      ../common/desktop/gaming

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ]
    ++ hardwareSetup;

  networking.hostName = "dianthus";
  time.timeZone = "Asia/Novosibirsk";
  i18n.defaultLocale = "en_DK.UTF-8";

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

  fileSystems."/".options = ["defaults" "noatime" "discard" "commit=60"];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 50;
  };

  users.users.danknil = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "corectrl"];
    shell = pkgs.zsh;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      danknil = ../../home-manager/dianthus/danknil.nix;
    };
  };

  programs = {
    corectrl = enabled' {
      gpuOverclock = enabled;
    };
    gnupg.agent = enabled' {
      enableSSHSupport = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    gamemode = enabled;
    direnv = enabled;
    zsh = enabled;
  };

  hardware = {
    bluetooth = enabled' {
      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
    };
  };

  environment = {
    # default packages
    systemPackages = with pkgs; [
      neovim
    ];

    # set EDITOR to neovim
    variables.EDITOR = "nvim";
  };

  chaotic = {
    mesa-git = enabled' {
      extraPackages = [pkgs.mesa_git.opencl];
      extraPackages32 = [pkgs.mesa_git.opencl];
    };
  };

  system.stateVersion = "23.11";
}
