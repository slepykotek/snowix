{ config, lib, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ] ++ lib.optional (builtins.pathExists /home/slepykotek/dotfiles/local.nix) /home/slepykotek/dotfiles/local.nix;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.kernelParams = [
    "intel_iommu=on"
    "kvmfr.static_size_mb=64"
    "kvm.ignore_msrs=1"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];  
  boot.initrd.kernelModules = ["vfio_pci" "vfio" "vfio_iommu_type1" "kvmfr"];

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 slepykotek qemu-libvirtd -"
  ];

  services.udev.packages = lib.singleton (pkgs.writeTextFile
   { 
     name = "kvmfr";
     text = ''
       SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
     '';
     destination = "/etc/udev/rules.d/70-kvmfr.rules";
    }
  );

  virtualisation.libvirtd.qemu = {
  verbatimConfig = ''
     namespaces = []
     cgroup_device_acl = [
       "/dev/null", "/dev/full", "/dev/zero",
       "/dev/random", "/dev/urandom",
       "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
       "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
       "/dev/kvmfr0"
      ]
    '';
  };
  
  networking.hostName = "0xvoid";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Touchpad support
  services.libinput.enable = true;

  users.users.slepykotek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.ssh.startAgent = true;

  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

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

  specialisation.vfio.configuration = {
    system.nixos.tags = [ "vfio" ];

    services.xserver.videoDrivers = lib.mkForce [ ];
    hardware.nvidia.open = lib.mkForce false;
    hardware.nvidia.prime.offload.enable = lib.mkForce false;
    hardware.nvidia.modesetting.enable = lib.mkForce false;

    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    boot.extraModprobeConfig = ''
      options vfio-pci ids=10de:2d59,10de:22eb
    '';
  };

  system.stateVersion = "26.05";
}

