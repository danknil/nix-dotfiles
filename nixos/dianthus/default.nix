# danknil's main pc config
{ lib
, pkgs
, inputs
, outputs
, ...
}:
let
  inherit (lib) enabled enabled';
  # get user config
in
{
  imports =  [
    # Home Manager
    inputs.home-manager.nixosModules.home-manager
    # NixOS styling
    inputs.stylix.nixosModules.stylix

    # import configuration modules
    outputs.nixosModules.default 

    # import common modules
    ../common/nix
    ../common/system/boot
    ../common/system/boot/sddm
    ../common/desktop
    ../common/desktop/gaming

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "dianthus";
  time.timeZone = "Asia/Novosibirsk";
  i18n.defaultLocale = "en_DK.UTF-8";

  fileSystems."/".options = [ "defaults" "noatime" "discard" "commit=60" ];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 50;
  };

  # gpu early init
  boot.initrd.kernelModules = [ "amdgpu" ];

  programs.zsh = enabled;
  users.users.danknil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "corectrl" ];
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
    hyprland = enabled' {
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

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

      gpu-screen-recorder # for replays
      custom.mons # modmanager for celeste
      r2modman # modmanager for unity games

      # minecraft for life :3
      (pkgs.prismlauncher.override {
        jdks = [ jdk8 temurin-bin-11 temurin-bin-17 temurin-bin ];
        withWaylandGLFW = true;
      })
    ];

    # set EDITOR to neovim
    variables.EDITOR = "nvim";
  };

  chaotic = {
    mesa-git = enabled' {
      extraPackages = [ pkgs.mesa_git.opencl ];
    };
  };

  system.stateVersion = "23.11";
}
