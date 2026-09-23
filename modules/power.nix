{ config, pkgs, ... }:

{

  services.power-profiles-daemon.enable = true;

  # for intel i guess
  services.thermald.enable = true;

}
