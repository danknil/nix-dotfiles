{ config
, ...
}:
let
  hDir = dir: "${config.home.homeDirectory}/${dir}";
in
{
  config = {
    xdg = {
      enable = true;
      mimeApps.enable = true;
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
  };
}
