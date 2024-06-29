{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8c4c4c66-e1c2-42bc-b461-bd9751f5c48e";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };

  boot.initrd.luks.devices."luks-1325132c-5530-48e4-9adb-388ce7a6ecec".device = "/dev/disk/by-uuid/1325132c-5530-48e4-9adb-388ce7a6ecec";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6B41-2508";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/3640f753-ff80-4e76-8b0b-34f0ae5a32f4"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
