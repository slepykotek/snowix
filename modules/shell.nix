{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

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
