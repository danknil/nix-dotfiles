{ options, config, pkgs, lib, inputs, ... }:

with lib;
let 
  cfg = config.danknil.home;
in
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  options.danknil.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    danknil.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions cfg.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions cfg.configFile;
    };

    home-manager = {
      useUserPackages = true;

      users.${config.danknil.user.name} =
        mkAliasDefinitions options.danknil.home.extraOptions;
    };
  };
}
