{ lib
, config
, pkgs
, ...
}:
with lib;
with lib.dnix;
{
  options.profiles.users = with types; {
    users = mkOpt
      (attrsOf (submodule (with types; {
        isSudo = mkEnableOption "wheel group";
        extraGroups = mkOpt (listOf str) [ ] "groups to append";
        options = mkOpt (attrsOf bool) { } "options to enable";
      })))
      { } "user list";
  };

  config =
    let
      userEnable =
        option: any (user: user.options.${option}) (attrValues config.profiles.users.users);
    in
    {
      users.users = mkMerge
        (mapAttrsToList
          (name: c: {
            ${name} = {
              isNormalUser = true;
              extraGroups =
                optional (c.isSudo) "wheel"
                ++ optional ((c.isSudo) && config.profiles.system.networking.enable) "networkmanager"
                ++ c.extraGroups;
              shell = mkIf c.options.zsh pkgs.zsh;
            };
          })
          config.profiles.users.users);
      programs = {
        # enable hyprland if any user have it enabled
        hyprland = mkIf (userEnable "hyprland") {
          enable = true;
          package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        };
        # enable zsh if user wants it
        zsh = mkIf (userEnable "zsh") enabled;
      };

      # enable udisks if any user wants to automount
      services.udisks2 = mkIf (userEnable "udiskie") enabled;

      profiles.system.graphics =
        mkIf
          (
            (userEnable "hyprland")
            || (userEnable "graphics")
          )
          enabled;
    };
}
