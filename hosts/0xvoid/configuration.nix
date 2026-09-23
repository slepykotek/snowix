{ config, lib, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../modules/virtualisation.nix
      ../../modules/user.nix
    ] ++ lib.optional (builtins.pathExists ../../modules/local.nix) ../../modules/local.nix;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  
  networking.hostName = "0xvoid";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.libinput.enable = true;

  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    kitty
    ly
    fastfetch
    hyprlauncher
    fetch
    sbctl
    tealdeer
    noctalia-shell
    efibootmgr
    jetbrains-toolbox
    vesktop
    nerd-fonts.jetbrains-mono
    kdePackages.dolphin
    mpv
    mpvpaper
    vscode
    gcc
    clang
    qemu
    dnsmasq
    gnome-tweaks
    gnome-themes-extra
    looking-glass-client
    git
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
 

  services.displayManager.ly = {
    enable = true;

    settings = {
      animation = "matrix";
      bigclock = true;
    };
  };
 
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };
  
  hardware.nvidia.modesetting.enable = true;

  system.stateVersion = "26.05";
}
