{ config, pkgs, ... }:

{
  home.username = "ahummaitra";
  home.homeDirectory = "/home/ahummaitra";

  home.stateVersion = "26.11";

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-emoji ];
  };

  programs.home-manager.enable = true;
}

