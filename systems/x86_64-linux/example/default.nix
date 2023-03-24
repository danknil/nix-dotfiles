{ pkgs, ... }:
let
  enable = x: { x.enabled = true; };
in
{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.example = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    firefox
  ];

  system.stateVersion = "22.11";
}
