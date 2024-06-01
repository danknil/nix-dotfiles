# danknil's main notebook config
{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:
let
  inherit (lib) enabled disabled enabled' generators;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.chaotic.nixosModules.default
      inputs.auto-cpufreq.nixosModules.default
    ];

  networking = {
    hostName = "nymphaea";
    networkmanager = enabled' {
      wifi = {
        backend = "iwd";
        powersave = true;
      }; 
    };
    firewall = disabled;
  };
  time.timeZone = "Asia/Novosibirsk";

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "commit=120" ];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;

    # blacklist watchdog modules
    extraModprobeConfig = ''
      blacklist iTCO_wdt
      blacklist sp5100_tco
    '';

    # disable watchdog and make boot quiet
    kernelParams = [
      "nowatchdog"
      "quiet"
      "loglevel=3"
      "systemd.show_status=false"
      "rd.udev.log_level=3"
    ];

    kernel.sysctl = {
      # disable kernel messages
      "kernel.printk" = "3 3 3 3";

      # **Some optimizations from steam deck**
      # 20-net-timeout.conf
      # This is required due to some games being unable to reuse their TCP ports
      # if they're killed and restarted quickly - the default timeout is too large.
      "net.ipv4.tcp_fin_timeout" = 5;

      # 30-vm.conf
      # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
      # see comment in include/linux/mm.h in the kernel tree.
      "vm.max_map_count" = 2147483642;
    };


    initrd = {
      # enable systemd at stage 1
      systemd = enabled' {
        # we dont want to wait-online
        network.wait-online = disabled;
      };
      kernelModules = [ "i915" ]; # early boot gpu module
      # not check ext4 filesystems by default at boot because it's faster
      checkJournalingFS = false;
    };


    loader = {
      timeout = 0;
      # this should be off after installation
      efi.canTouchEfiVariables = false;
      # setting systemd-boot for all setups
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };

    plymouth = enabled' {
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override
          {
            selected_themes = [ "deus_ex" ];
          })
      ];
      theme = "deus_ex";
    };
  };

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };
  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
        persistent = true;
      };
      optimise.automatic = true;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      extraOptions = ''
        keep-outputs = true
        warn-dirty = false
        keep-derivations = true
        use-xdg-base-directories = true
      '';
      settings = {
        accept-flake-config = true;
        nix-path = config.nix.nixPath;
        allowed-users = [ "@wheel" ];
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        builders-use-substitutes = true;
        experimental-features = [
          "auto-allocate-uids"
          "ca-derivations"
          "cgroups"
          "flakes"
          "nix-command"
          "recursive-nix"
        ];
        flake-registry = "/etc/nix/registry.json";
        http-connections = 50;
        keep-going = true;
        log-lines = 20;
        max-jobs = "auto";
        sandbox = true;
        trusted-users = [ "root" "@wheel" ];
        use-cgroups = true;
        warn-dirty = false;
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    };
  nixpkgs = {
    # You can add overlays here
    overlays = with outputs.overlays; [
      additions
      modifications
      stable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  users.users.danknil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "corectrl" ];
    shell = pkgs.zsh;
  };

  programs = {
    corectrl = enabled' {
      gpuOverclock = enabled;
    };
    hyprland = enabled' {
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    zsh = enabled;

    gamemode = enabled;
    gamescope.package = pkgs.gamescope_git;
    steam = enabled' {
      package = pkgs.steam.override {
        extraPkgs = p: with p; [
          bluez
          bluez-tools
        ];
      };
      gamescopeSession = enabled' {
        args = [ "-O DP-1,*" ];
      };
    };
  };

  hardware = {
    bluetooth = enabled' {
      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
    };
  };

  # Select internationalisation properties.
  # using this because it closer to russian
  i18n.defaultLocale = "en_DK.UTF-8";

  environment = {
    systemPackages = with pkgs; [
      # tpm unlock
      tpm2-tss

      neovim
      git
      wget
      elegant-sddm

      bottles

      vkbasalt
      mangohud
      gamescope # import just in case
      protontricks # for game fixes
      gpu-screen-recorder # for replays
      # custom.mons # modmanager for celeste
      r2modman # modmanager for unity games

      (pkgs.prismlauncher.override {
        jdks = [ jdk8 temurin-bin-11 temurin-bin-17 temurin-bin ];
        withWaylandGLFW = true;
      })

      # (elegant-sddm.override {
      #   themeConfig.General = {
      #     background = "${./saber-dark.png}";
      #   };
      # })
    ];

    # set EDITOR to neovim
    variables.EDITOR = "nvim";
  };

  programs = { };

  # better dbus implementation
  services.dbus.implementation = "broker";

  # enabling all firmware because there is no reason i dont want it
  hardware.enableAllFirmware = true;

  services.displayManager.sddm = enabled' {
    package = (pkgs.kdePackages.sddm.override {
      withWayland = true;
    });
    wayland = enabled;
    extraPackages = [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
    theme = "Elegant";
  };

  systemd.services."plymouth-transition" = enabled' {
    # taken from arch wiki https://wiki.archlinux.org/title/Plymouth#Smooth_transition
    unitConfig = {
      Conflicts = "plymouth-quit.service";
      After = "plymouth-quit.service rc-local.service plymouth-start.service systemd-user-sessions.service";
      OnFailure = "plymouth-quit.service";
    };

    serviceConfig = {
      ExecStartPre = "-/usr/bin/plymouth deactivate";
      ExecStartPost = [ "-/usr/bin/sleep 30" "-/usr/bin/plymouth quit --retain-splash" ];
    };
  };


  # disable sound because it isn't designed to use with pipewire
  sound = disabled;


  security.rtkit = enabled;
  services = {
    fstrim = enabled;
    udisks2 = enabled;
    pipewire =
      let
        quantum = 64;
        rate = 48000;
        qr = "${toString quantum}/${toString rate}";
      in
      {
        enable = true;
        alsa = enabled' {
          support32Bit = true;
        };
        pulse = enabled;
        jack = enabled;

        extraConfig.pipewire =
          {
            "99-lowlatency" = {
              context = {
                properties.default.clock.min-quantum = quantum;
                modules = [
                  {
                    name = "libpipewire-module-rtkit";
                    flags = [ "ifexists" "nofail" ];
                    args = {
                      nice.level = -15;
                      rt = {
                        prio = 88;
                        time.soft = 200000;
                        time.hard = 200000;
                      };
                    };
                  }
                  {
                    name = "libpipewire-module-protocol-pulse";
                    args = {
                      server.address = [ "unix:native" ];
                      pulse.min = {
                        req = qr;
                        quantum = qr;
                        frag = qr;
                      };
                    };
                  }
                ];

                stream.properties = {
                  node.latency = qr;
                  resample.quality = 1;
                };
              };
            };
          };
        # ensure WirePlumber is enabled explicitly (defaults to true while PW is enabled)
        # and write extra config to ship low latency rules for alsa
        wireplumber = enabled' {
          configPackages =
            let
              # generate "matches" section of the rules
              matches = generators.toLua
                {
                  multiline = false; # looks better while inline
                  indent = false;
                } [ [ [ "node.name" "matches" "alsa_output.*" ] ] ]; # nested lists are to produce `{{{ }}}` in the output

              # generate "apply_properties" section of the rules
              apply_properties = generators.toLua { } {
                "audio.format" = "S32LE";
                "audio.rate" = rate * 2;
                "api.alsa.period-size" = 2;
              };
            in
            [
              (pkgs.writeTextDir "share/lowlatency.lua.d/99-alsa-lowlatency.lua" ''
                alsa_monitor.rules = {
                  {
                    matches = ${matches};
                    apply_properties = ${apply_properties};
                  }
                }
              '')
            ];
        };
      };
  };
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

  # profiles = {
  #   # users.users = {
  #   #   danknil = {
  #   #     isSudo = true;
  #   #     options = {
  #   #       hyprland = true;
  #   #       zsh = true;
  #   #       udiskie = true;
  #   #     };
  #   #   };
  #   # };
  #   gaming = enabled' {
  #     enableMinecraft = true;
  #   };
  #   sddm = enabled;
  #   system = {
  #     sound = enabled' {
  #       lowLatency = enabled;
  #     };
  #     network = enabled;
  #     bluetooth = true;
  #     splash = true;
  #     ssd = true;
  #     graphics = {
  #       extraPackages = 
  #       hdr = false;
  #     };
  #   };
  # };
  system.stateVersion = "23.11";
}
