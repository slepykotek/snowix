{ config, lib, pkgs, ... }:

{

  users.users.slepykotek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.ssh.startAgent = true;

}