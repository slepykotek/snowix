{ config, lib, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../modules/virtualization.nix
      ../../modules/user.nix
      ../../modules/shell.nix
      ../../modules/power.nix
      ../../modules/shared.nix
    ] ++ lib.optional (builtins.pathExists /home/slepykotek/dotfiles/modules/local.nix) /home/slepykotek/dotfiles/modules/local.nix;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  
  networking.hostName = "0xvoid";

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

  programs.niri.enable = true;

  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  programs.nh = {
    enable = true;
    flake = "/home/slepykotek/dotfiles";

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 3 --keep-since 7d";
    };
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
    #noctalia-shell # - package broke so no bar and lockscreen for now :(
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
    nh
    clang-tools
    pyright
    nixd
    # replacements until noctalia compiles correctly
    waybar
    fuzzel

    (pkgs.stdenv.mkDerivation {
      name = "glyph-sddm";
      src = pkgs.fetchFromGitHub {
        owner = "slepykotek";
        repo = "glyph-sddm";
        rev = "main";
        hash = "sha256-Zw7JsKVh0in5anbI6WYlmOZhzjENTxlDgtofci01ymk=";
      };
      installPhase = ''
        mkdir -p $out/share/sddm/themes/glyph
        cp -r * $out/share/sddm/themes/glyph/
      '';
    })
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
 

  services.displayManager = {
    ly.enable = false;
    
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "glyph";
      package = pkgs.kdePackages.sddm;

      extraPackages = with pkgs.kdePackages; [
        qtdeclarative
        qtsvg
        qt5compat
      ];

      settings = {
        Theme = {
          CursorTheme = "breeze_cursors";
        };
      };
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
