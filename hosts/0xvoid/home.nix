{ config, pkgs, ... }:

{
  home.username = "slepykotek";
  home.homeDirectory = "/home/slepykotek";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
