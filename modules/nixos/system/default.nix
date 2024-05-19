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
        # better dbus implementation
        services.dbus.implementation = "broker";

        # enabling all firmware because there is no reason i dont want it
        hardware.enableAllFirmware = mkDefault true;

        boot = {
          initrd = {
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

      (mkIf cfg.graphics.enable {
        # hardware.opengl = enabled' {
        #   driSupport = true;
        #   driSupport32Bit = true;
        #   extraPackages = cfg.graphics.extraPackages;
        # };
        chaotic = {
          # also enables gamescope-wsi and linux-cachyos
          hdr = mkIf cfg.graphics.hdr (enabled' {
            wsiPackage = pkgs.gamescope-wsi_git;
            specialisation = disabled;
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

      (mkIf (cfg.sound.lowLatency.enable && cfg.sound.enable) {
        services.pipewire = {
        };
      })
    ];
}
