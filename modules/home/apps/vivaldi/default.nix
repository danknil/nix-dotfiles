{ lib
, pkgs
, config
, ...
}:
let cfg = config.apps.vivaldi;
in
with lib;
with lib.dnix;
{
  options.apps.vivaldi = {
    enable = mkEnableOption "Enable vivaldi browser";
  };
  config = lib.mkIf cfg.enable {
    programs.vivaldi = enabled' {
      package = pkgs.vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      };

      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
        { id = "npgcnondjocldhldegnakemclmfkngch"; } # anti zapret vpn
        { id = "mmjbdbjnoablegbkcklggeknkfcjkjia"; } # custom new tab url
      ];
    };
  };
}
