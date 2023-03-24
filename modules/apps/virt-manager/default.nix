{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.danknil.apps.virt-manager;
in
{
  options.danknil.apps.virt-manager = with types; {
    enable = mkBoolOpt false "Enable virt-manager with qemu/kvm emulation";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    danknil.user.extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
      win-qemu
      OVMFFull
    ];
  };
}
