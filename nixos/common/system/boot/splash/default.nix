{ lib
, pkgs
, ...
}:
let
  inherit (lib) enabled';
in
{

  boot.plymouth = enabled' {
    # themePackages = [
    #   (pkgs.adi1090x-plymouth-themes.override
    #     {
    #       selected_themes = [ "deus_ex" ];
    #     })
    # ];
    # theme = "deus_ex";
  };
}
