{ lib
, config
, pkgs
, ...
}:
with lib;
with lib.dnix;
let cfg = config.profiles.system;
in
{
  options.profiles.system = with types; {
    sound = {
      enable = mkEnableOption "Sound";
      lowLatency = {
        enable = mkEnableOption "Low latency config";
        quantum = mkOpt' int 64;
        rate = mkOpt' int 48000;
      };
    };
    network = {
      enable = mkEnableOption "NetworkManager";
      wireless = mkEnableOption "WiFi";
    };
    bluetooth = mkEnableOption "Bluetooth";
    splash = mkEnableOption "Plymouth";
    gamingOptions = mkEnableOption "sysctl config for gaming";
    graphics = {
      enable = mkEnableOption "mesa";
      hdr = mkEnableOption "HDR support";
      extraPackages = mkOpt' (listOf package) [ ];
    };
    ssd = mkEnableOption "fstrim timer for ssd";
  };
  config = mkMerge
    [
      {
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

        # better dbus implementation
        services.dbus.implementation = "broker";

        # enabling all firmware because there is no reason i dont want it
        hardware.enableAllFirmware = mkDefault true;

        boot = {
          # use this kernel by default
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

          # disable kernel messages
          kernel.sysctl = {
            "kernel.printk" = "3 3 3 3";
          };

          initrd = {
            # not check ext4 filesystems by default at boot because it's faster
            checkJournalingFS = mkDefault false;
            # enable systemd at stage 1
            systemd = enabled' {
              # we dont want to wait-online
              network.wait-online = disabled;
            };
          };

          loader = {
            timeout = 0;
            # this should be off after installation
            efi.canTouchEfiVariables = mkDefault false;
            # setting systemd-boot for all setups
            systemd-boot = {
              enable = true;
              editor = false;
            };
          };
        };
      }

      (mkIf cfg.ssd {
        # default weekly timer is fine
        services.fstrim = enabled;
      })

      (mkIf cfg.bluetooth {
        hardware.bluetooth = enabled' {
          powerOnBoot = true;
          package = pkgs.bluez;
          input.General.ClassicBondedOnly = false;
        };
      })

      (mkIf cfg.graphics.enable {
        # hardware.opengl = enabled' {
        #   driSupport = true;
        #   driSupport32Bit = true;
        #   extraPackages = cfg.graphics.extraPackages;
        # };
        chaotic = {
          mesa-git = enabled' {
            extraPackages = cfg.graphics.extraPackages;
          };
          # also enables gamescope-wsi and linux-cachyos
          hdr = mkIf cfg.graphics.hdr (enabled' {
            wsiPackage = pkgs.gamescope-wsi_git;
          });
        };
      })

      (mkIf cfg.splash {
        boot.plymouth = enabled' {
          themePackages = [
            (pkgs.adi1090x-plymouth-themes.override
              {
                selected_themes = [ "deus_ex" ];
              })
          ];
          theme = "deus_ex";
        };
        systemd.services."plymouth-transition" = mkIf config.profiles.sddm.enable (enabled' {
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
        });
      })

      (mkIf cfg.gamingOptions {
        boot.kernel.sysctl = {
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
      })

      (mkIf cfg.network.enable {
        networking = {
          networkmanager = enabled' {
            wifi = mkIf cfg.network.wireless {
              backend = "iwd";
            };
          };
          firewall = enabled;
        };
      })

      (mkIf cfg.sound.enable {
        # disable sound because it isn't designed to use with pipewire
        sound = disabled;

        security.rtkit = enabled;
        services.pipewire = enabled' {
          alsa = enabled' {
            support32Bit = true;
          };
          pulse = enabled;
          jack = enabled;
        };
      })

      (mkIf (cfg.sound.lowLatency.enable && cfg.sound.enable) {
        services.pipewire = {
          extraConfig.pipewire =
            let
              qr = "${toString cfg.sound.lowLatency.quantum}/${toString cfg.sound.lowLatency.rate}";
            in
            {
              "99-lowlatency" = {
                context = {
                  properties.default.clock.min-quantum = cfg.sound.lowLatency.quantum;
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
                  "audio.rate" = cfg.sound.lowLatency.rate * 2;
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
      })
    ];
}
