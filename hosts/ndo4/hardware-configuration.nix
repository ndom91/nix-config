{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" "zenpower" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];

  boot.blacklistedKernelModules = [ "k10temp" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/31113345-8fa1-43bc-b86b-0b761476e364";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };

  boot.initrd.luks.devices."luks-e5348a59-5d74-4aa4-ae7c-fa45614a94a7".device = "/dev/disk/by-uuid/e5348a59-5d74-4aa4-ae7c-fa45614a94a7";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C142-3835";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/37076c27-af0d-40e1-b86d-a6548072d226"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
