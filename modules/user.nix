{ config, pkgs, lib, ... }:

{

  users.users.slepykotek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" ];
    shell = pkgs.zsh;
  };

  programs.ssh.startAgent = true;

}
