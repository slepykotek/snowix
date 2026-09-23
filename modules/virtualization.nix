{ config, lib, pkgs, ... }:

{
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

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

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
}
