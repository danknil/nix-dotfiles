{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.editor.nvim;
in
with lib;
with lib.dnix;
{
  # options.editor.nvim = {
    # enable = mkEnableOption "neovim config";
  # };
# 
  # config = mkIf cfg.enable {
    # programs.nixvim = enabled' {
      # viAlias = true;
      # vimAlias = true;
      # opts = {
        # laststatus = 3;
        # showmode = false;
# 
        # title = true;
        # clipboard = "unnamedplus";
        # fillchars = { eob = " "; };
        # ignorecase = true;
        # smartcase = true;
        # mouse = "nv";
        # mousemodel = "extend";
# 
        # # Numbers
        # number = true;
        # relativenumber = true;
        # numberwidth = 2;
        # ruler = false;
# 
        # # disable nvim intro
        # shortmess = "FcsIW";
# 
        # # fold settings
        # foldexpr = "nvim_treesitter#foldexpr()";
        # foldmethod = "expr";
        # foldlevelstart = 99;
# 
        # signcolumn = "yes";
        # splitbelow = true;
        # splitright = true;
        # tabstop = 8;
        # termguicolors = true;
        # timeoutlen = 400;
        # undofile = true;
        # scrolloff = 8;
        # sidescrolloff = 8;
      # };
      # globals = {
        # mapleader = " ";
        # netrw_banner = 0;
      # };
# 
      # colorschemes.base16 = enabled' {
        # customColorScheme = { inherit (config.colorscheme) colors; };
      # };
# 
      # plugins = {
        # comment = enabled;
        # leap = enabled;
        # sleuth = enabled;
        # barbecue = enabled;
        # obsidian = enabled;
      # };
    # };
  # };
}
