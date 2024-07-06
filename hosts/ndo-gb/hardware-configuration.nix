{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "xe" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "xe.force_probe=7d45" ];
  boot.kernelModules = [ "kvm-intel" ];
  # boot.kernelModules = [ "kvm-intel" "mhi_pci_generic" "wwan" "wwan_hwsim" "usbserial" "option" "mhi_net" "iosm" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/db9840e3-6a9f-438e-bebe-5ebd7dbaf90f";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };

  boot.initrd.luks.devices."luks-6fd6a22f-839b-4eeb-8f18-cd0173d085a7".device = "/dev/disk/by-uuid/6fd6a22f-839b-4eeb-8f18-cd0173d085a7";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A9CC-D1F7";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/26ce4db0-837a-459a-b06f-92ce292bb3e2"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
