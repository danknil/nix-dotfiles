{ lib, modulesPath, pkgs, ... }:
with lib;
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Novosibirsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "amd_pstate=passive"
  ];
  boot.initrd.kernelModules = [
    "dm-cache-default"
    "amdgpu"
  ];
  # WARN: Better luck next time
  # boot.plymouth = {
  #   enable = true;
  # };
  # programs.dconf = enabled;
  # services.xserver.displayManager = {
  #   # defaultSession = "hyprland";
  #   gdm = {
  #     enable = true;
  #     wayland = true;
  #   };
  # };

  hardware.cpu.amd.updateMicrocode = true;

  # add rocm for opencl compute
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
  };

  environment.systemPackages = with pkgs; [
    tdesktop
    busybox
    wget
    killall
    git-credential-keepassxc
    keepassxc
    httpie
    soundux
    gimp
    neovim

    prismlauncher
    mangohud
    bottles

    swww
    grim
    slurp
    libsForQt5.polkit-kde-agent
    wl-clipboard
    imv
    wf-recorder

    xdg-utils
    pango
    python3Minimal
    python310Packages.pip
    luajitPackages.luarocks-nix
    gcc
  ];

  networking = {
    hostName = "dankpc"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    firewall = disabled;
  };

  services.fstrim.enable = lib.mkDefault true;
  services.openssh = enabled;

  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = {
        # command = "${pkgs.cage}/bin/cage -m last -d -- ${pkgs.greetd.regreet}/bin/regreet";
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        user = "loginuser";
      };
    };
  };

  users.users.loginuser = {
    group = "users";
    isNormalUser = true;
    createHome = false;
    description = "user for login";
    extraGroups = [ "video" "audio" ];
    packages = with pkgs; [ cage greetd.greetd greetd.regreet ];
  };


  # enables completion for zsh
  environment.pathsToLink = [ "/share/zsh" ];

  danknil = {
    system = enabled;
    desktop.hyprland.enable = true;
    user = {
      name = "danknil";
      fullName = "Mikhail Balashov";
      email = "danknil@protonmail.com";
      extraGroups = [ "networkmanager" "libvirtd" ];
    };

    hardware = {
      audio = enabled;
    };

    apps = {
      alacritty = enabled;
      chromium = enabled;
      discord = enabled;
      gallery-dl = enabled;
      gamemode = enabled;
      gamescope = enabled;
      mpv = enabled;
      obs-studio = enabled;
      obsidian = enabled;
      qutebrowser = enabled;
      rofi = enabled;
      rtorrent = enabled;
      spotify = enabled;
      thunar = enabled;
      virt-manager = enabled;
      yt-dlp = enabled;
    };
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
    # for a WiFi printer
    openFirewall = true;
  };

  system.stateVersion = "23.11";
}
