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
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles

      vkbasalt
      mangohud
      gamescope # import just in case
      protontricks # for game fixes
      gpu-screen-recorder # for replays
      dnix.mons # modmanager for celeste
      r2modman # modmanager for unity games
    ];

    programs = {
      gamemode = enabled;
      steam = enabled' {
        extraCompatPackages = with pkgs; [
          dnix.steamtinkerlaunch
          proton-ge-bin
        ];
        gamescopeSession = enabled;
      };
    };
  };
}
