{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.desktop.hyprland;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  options.danknil.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable Hyprland window manager and related addons";
    extraConfig = mkOpt str "" "add config on top of current hyprland config(workspaces, wsbind, monitor config)";
  };

  config = mkIf cfg.enable {
    # TODO: move polkit to module
    # security.polkit.enable = true;
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    # enabling addons
    # WARN: do i need to enable swayidle there?
    # danknil.desktop.addons = {
    #   cursor = enabled;
    #   theming = enabled;
    # };

    danknil.home.extraOptions =
    {
      imports = [ inputs.hyprland.homeManagerModules.default ];
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland = enabled;

        package = null;
        extraConfig =
          ''
            ${cfg.extraConfig}
            ${lib.strings.fileContents ./hyprland.conf}
          '';
      };
    };
  };
}
