{pkgs, ...}: {
  home.packages = with pkgs; [
    passExtensions.pass-tomb
    passExtensions.pass-genphrase
    passExtensions.pass-update
    pass
    fzf
    fd
    git
    (writeScriptBin "passfzf" (builtins.readFile ./passfzf))
  ];
}
