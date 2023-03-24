{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.thunar;
in
{
  options.danknil.apps.thunar = with types; {
    enable = mkBoolOpt false "Enable thunar file explorer";
    enablePreviews = mkBoolOpt cfg.enable "Enable thunar previews";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    services.tumbler.enable = cfg.enablePreviews;

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
      ];
    };

    environment.systemPackages =
      [
        pkgs.lxqt.lxqt-archiver
      ]
      ++
      optionals cfg.enablePreviews (with pkgs; [
        ffmpegthumbnailer
        libgsf
        webp-pixbuf-loader
        poppler
        gnome-epub-thumbnailer
      ]);
  };
}
