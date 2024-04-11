{ lib
, config
, pkgs
, ...
}:
with lib;
with lib.dnix;
let cfg = config.profiles.gaming;
in {
  options.profiles.gaming = {
    enable = mkEnableOption "gaming";
    enableMinecraft = mkEnableOption "minecraft";
  };

  config = mkIf cfg.enable {
    profiles.system = {
      gamingOptions = true;
      graphics = enabled;
    };

    environment.systemPackages = with pkgs; [
      bottles

      vkbasalt
      mangohud
      gamescope # import just in case
      protontricks # for game fixes
      gpu-screen-recorder # for replays
      dnix.mons # modmanager for celeste
      r2modman # modmanager for unity games
    ] ++ optional cfg.enableMinecraft (pkgs.prismlauncher.override {
      jdks = [ jdk8 temurin-bin-11 temurin-bin-17 temurin-bin ];
      # withWaylandGLFW = true;
    });

    chaotic.steam.extraCompatPackages = with pkgs; [
      dnix.steamtinkerlaunch
      proton-ge-bin
    ];

    programs = {
      gamemode = enabled;
      # gamescope.package = pkgs.gamescope_git;
      steam = enabled' {
        package = pkgs.steam.override {
          extraPkgs = p: with p; [ bluez bluez-tools ];
        };
        gamescopeSession = enabled;
      };
    };
  };
}
