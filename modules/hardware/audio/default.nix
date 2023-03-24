{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.danknil.hardware.audio;
in
{
  options.danknil.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
    alsa-monitor = mkOpt attrs { } "Alsa configuration.";
    nodes = mkOpt (listOf attrs) [ ]
      "Audio nodes to pass to Pipewire as `context.objects`.";
    modules = mkOpt (listOf attrs) [ ]
      "Audio modules to pass to Pipewire as `context.modules`.";
    extra-packages = mkOpt (listOf package) [] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # wireplumber.enable = true;
      #
      # config.pipewire = {
      #   "context.objects" = [ ] ++ cfg.nodes;
      #   "context.modules" = [ ] ++ cfg.modules;
      # };
    };

    environment.systemPackages = with pkgs; [
      pulsemixer
      pavucontrol
      easyeffects
    ] ++ cfg.extra-packages;

    # danknil.home.extraOptions = {
    #   systemd.user.services.mpris-proxy = {
    #     Unit.Description = "Mpris proxy";
    #     Unit.After = [ "network.target" "sound.target" ];
    #     Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    #     Install.WantedBy = [ "default.target" ];
    #   };
    # };
  };
}
