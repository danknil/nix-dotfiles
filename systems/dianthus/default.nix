# danknil's main pc config
{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:
let
  inherit (lib) enabled disabled enabled' forEach generators;
  getModules = names: forEach names (name: outputs.nixosModules.${name});
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ] ++ getModules [
      "nix"
      "system"
    ];

  networking = {
    hostName = "dianthus";
    networkmanager = enabled;
    firewall = disabled;
  };
  time.timeZone = "Asia/Novosibirsk";

  fileSystems."/".options = [ "defaults" "noatime" "discard" "commit=60" ];

  zramSwap = enabled' {
    priority = 100;
    memoryPercent = 80;
  };

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
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

    # not check ext4 filesystems by default at boot because it's faster
    checkJournalingFS = false;
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
    steam.gamescopeSession.args = [ "-O DP-1,*" ];
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
    # default packages
    systemPackages = with pkgs; [
      neovim
      git
      wget
    ];

    # set EDITOR to neovim
    variables.EDITOR = "nvim";
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
