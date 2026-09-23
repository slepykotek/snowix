{ config, pkgs, ... }:

{
  programs.zsh.enable = true;


  environment.systemPackages = with pkgs; [
    nh
    lazygit
    glow
    eza
    bat
    fzf
    starship
  ];
}
