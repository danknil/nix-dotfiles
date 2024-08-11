{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) types mkIf mkOpt mkEnableOption enabled' generators;

  cfg = config.services.pipewire;
  cfgll = cfg.lowLatency;

  rate = cfgll.rate;
  quantum = cfgll.quantum;
  qr = "${toString quantum}/${toString rate}";
in {
  options.services.pipewire = with types; {
    lowLatency = {
      enable = mkEnableOption "Low latency config";
      quantum = mkOpt int 64 "quantum setting";
      rate = mkOpt int 48000 "rate setting";
    };
  };

  config = mkIf cfgll.enable {
    services = {
      pipewire = {
        extraConfig.pipewire = {
          "99-lowlatency" = {
            context = {
              properties.default.clock.min-quantum = quantum;
              modules = [
                {
                  name = "libpipewire-module-rtkit";
                  flags = ["ifexists" "nofail"];
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
                    server.address = ["unix:native"];
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
          configPackages = let
            # generate "matches" section of the rules
            matches =
              generators.toLua
              {
                multiline = false; # looks better while inline
                indent = false;
              } [[["node.name" "matches" "alsa_output.*"]]]; # nested lists are to produce `{{{ }}}` in the output

            # generate "apply_properties" section of the rules
            apply_properties = generators.toLua {} {
              "audio.format" = "S32LE";
              "audio.rate" = rate * 2;
              "api.alsa.period-size" = 2;
            };
          in [
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
  };
}
