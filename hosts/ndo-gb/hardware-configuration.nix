{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Both i915 and xe are compatible with this laptop's iGPU, sometimes apps have issues with one or the other 
  # though, so every few months I find myself switching back and forth and checking if "'xe' is ready yet".
  # boot.initrd.kernelModules = [ "i915" ];
  # boot.kernelParams = [ "i915.force_probe=7d45" "mitigations=off" ];
  boot.initrd.kernelModules = [ "xe" ];
  boot.kernelParams = [ "xe.force_probe=7d45" "mitigations=off" ];

  boot.kernelModules = [ "kvm-intel" ];
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
