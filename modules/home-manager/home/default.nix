{
  config,
  lib,
  ...
}:
with lib;
with lib.dnix; let
  cfg = config.profile.user;
in {
  options.profile.user = with types; rec {
    email = mkOpt str "" "email to use associate with this user";
    hostName = mkOpt str (builtins.getEnv "USER") "username";
    fullName = mkOpt str hostName "full name of user, default to hostname";
  };
  config = {
    programs = {
      home-manager = enabled;
      git = enabled' {
        delta = enabled;
        userEmail = cfg.email;
        userName = cfg.hostName;
      };
    };
    fonts.fontconfig = enabled;
  };
}
