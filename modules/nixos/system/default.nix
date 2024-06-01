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
      })

      (mkIf (cfg.sound.lowLatency.enable && cfg.sound.enable) {
        services.pipewire = {
        };
      })
    ];
}
