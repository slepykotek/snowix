{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      cat = "bat";
      lg = "lazygit";
      update = "nh os switch -- --impure";
      upgrade = "nh os switch -u -- --impure";
     };
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
}
