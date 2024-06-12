{config, ...}: let
  hDir = dir: "${config.home.homeDirectory}/${dir}";
in {
  xdg = {
    enable = true;
    mimeApps.enable = true;

    cacheHome = hDir ".cache";
    configHome = hDir ".config";
    dataHome = hDir ".local/share";
    stateHome = hDir ".local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
      documents = hDir "Documents";
      download = hDir "Downloads";
      music = hDir "Music";
      pictures = hDir "Pictures";
      publicShare = hDir "Public";
      templates = hDir "Templates";
      videos = hDir "Videos";
    };
  };
  # setting xdg env vars because home-manager dont do it by itself
  home.sessionVariables = with config.xdg; {
    XDG_CACHE_HOME = cacheHome;
    XDG_CONFIG_HOME = configHome;
    XDG_DATA_HOME = dataHome;
    XDG_STATE_HOME = stateHome;
  };
}
