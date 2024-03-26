_: {
  # setting systemd-boot for all setups
  boot = {
    initrd.systemd.enable = true;
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };
}
