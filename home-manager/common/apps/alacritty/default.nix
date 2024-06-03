_: {
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = false;
      window = {
        padding = { x = 20; y = 20; };
        dynamic_title = false;
        dynamic_padding = true;
      };
      # font = {
      #   normal = { family = "SauceCodePro Nerd Font Mono"; style = "Regular"; };
      #   size = 16;
      # };
      cursor = {
        style = "Underline";
        thickness = 0.2;
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
