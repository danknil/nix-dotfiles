{
  lib,
  pkgs,
  outputs,
  ...
}: let
  inherit (lib) enabled enabled';
in {
  imports = [
    outputs.nixosModules.default
  ];

  # enable lowLatency for gaming
  services.pipewire.lowLatency = enabled;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  environment.systemPackages = with pkgs; [
    bottles

    vkbasalt
    mangohud
    protonup # for installing proton
  ];

  programs = {
    gamemode = enabled;
    gamescope.package = pkgs.gamescope_git;
    steam = enabled' {
      protontricks.enable = true;
      package = pkgs.steam.override {
        extraPkgs = p:
          with p; [
            bluez
            bluez-tools
          ];
      };
      gamescopeSession = enabled' {
        args = ["-O DP-1,*"];
      };
    };
  };
}
