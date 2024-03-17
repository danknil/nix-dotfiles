{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.rtorrent;
in
{
  options.danknil.apps.rtorrent = with types; {
    enable = mkBoolOpt false "Enable rtorrent(with flood gui backend)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ rtorrent ];
    danknil.home.extraOptions = {
      programs.rtorrent = enabled;
      # INFO: possibly using desktop entry?
      systemd.user.services.flood = {
        Unit = {
          Description = "Flood service for %I";
          After = "network.target";
        };
        Service = {
          User = "%I";
          Group = "%I";
          Type = "Simple";
          KillMode = "process";
          ExecStart = "/usr/bin/env ${pkgs.flood}/bin/flood";
          Restart = "on-failure";
          RestartSec = 3;
        };
        Install = {
          WantedBy = [ "multi-user.target" ];
        };
      };
    };
  };
}
