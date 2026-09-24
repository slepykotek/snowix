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
    zoxide
  ];

  shellAliases = {
   ls = "eza";
   ll = "eza -l";
   la = "eza -la";
   lt = "eza --tree";
   cat = "bat";
   lg = "lazygit";
  };
}
