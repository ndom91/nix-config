########################################################################
# REPLACE WITH /etc/nixos/hardware-configuration.nix AFTER INTALLATION #
########################################################################
# X1 11G Config: https://github.com/NixOS/nixos-hardware/blob/master/lenovo/thinkpad/x1/11th-gen/default.nix

{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "xe" "acpi_call" ]; # FORCE 'xe' INTEL DRIVER
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ "i915.force_probe=!7d55" ];
  boot.kernelParams = [ "xe.force_probe=7d55" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

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
