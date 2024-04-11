{ config
, lib
, pkgs
, inputs
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

  networking.hostName = "dankpc";
  time.timeZone = "Asia/Novosibirsk";

  fileSystems."/".options = [ "defaults" "noatime" "discard" "commit=60" ];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  users.users.danknil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "corectrl" ];
    shell = pkgs.zsh;
  };

  services.udisks2 = enabled;

  programs = {
    corectrl = enabled' {
      gpuOverclock = enabled;
    };
    hyprland = enabled' {
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    zsh = enabled;
    steam.gamescopeSession.args = [ "-O DP-1,*" ];
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
      sound = enabled' {
        lowLatency = enabled;
      };
      network = enabled;
      bluetooth = true;
      splash = true;
      ssd = true;
      graphics = {
        extraPackages = [ pkgs.mesa_git.opencl ];
        hdr = true;
      };
    };
  };
  system.stateVersion = "23.11";
}
