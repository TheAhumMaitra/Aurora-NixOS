{ config, lib, pkgs, ... }:

let
  vars = import ./variables.nix { inherit lib; };
in

{
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  home.stateVersion = "26.11";

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-emoji ];
  };

  programs.home-manager.enable = true;
}

