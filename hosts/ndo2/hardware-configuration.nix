{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/8c4c4c66-e1c2-42bc-b461-bd9751f5c48e";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-1325132c-5530-48e4-9adb-388ce7a6ecec".device = "/dev/disk/by-uuid/1325132c-5530-48e4-9adb-388ce7a6ecec";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/6B41-2508";
      fsType = "vfat";
    };

  swapDevices = [
    # { device = "/dev/disk/by-uuid/e8eb66dd-9508-488b-8e56-07ef33d83218"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
