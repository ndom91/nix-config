{ config, pkgs, lib, modulesPath, ... }:
with lib;
let
  # https://github.com/nh2/nixos-vm-examples
  mount_guest_path = "/home/ndo/VMs/";
  mount_host_path = toString ./.; # our `nixos-vm-examples` dir
  mount_tag = "hostdir"; # just a label tag for qemu mounts
in
{
  imports = [
    (modulesPath + "/installer/netboot/netboot-base.nix")
  ];

  boot = {
    growPartition = true;
    kernelParams = [ "console=ttyS0 boot.shell_on_fail" ];
    loader.timeout = 5;

    # Mount nixpkgs submodule at `/root/nixpkgs` in guest.
    initrd.postMountCommands = ''
      mkdir -p "$targetRoot/${mount_guest_path}"
      mount -t 9p "${mount_tag}" "$targetRoot/${mount_guest_path}" -o trans=virtio,version=9p2000.L,cache=none
    '';

    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
      netbootxyz.enable = true;
    };
    loader.efi.canTouchEfiVariables = true;

    # Copy VM configuration into guest so that we can use `nixos-rebuild` in there.
    postBootCommands = ''
      cp ${./configuration.nix} /etc/nixos/configuration.nix
    '';
  };


  virtualisation = {
    diskSize = 8000; # MB
    memorySize = 2048; # MB
    qemu.options = [
      "-virtfs local,path=${mount_host_path},security_model=none,mount_tag=${mount_tag}"
    ];

    # We don't want to use tmpfs, otherwise the nix store's size will be bounded
    # by a fraction of available RAM.
    writableStoreUseTmpfs = false;
  };


  networking = {
    hostName = "ndo4-netboot";
    useDHCP = false;
    networkmanager.enable = true;
    # nameservers = [
    #   "10.0.0.1"
    # ];
    # interfaces = {
    #   eth0 = {
    #     useDHCP = false;
    #     ipv4 = {
    #       addresses = [{
    #         address = "10.0.0.10";
    #         prefixLength = 24;
    #       }];
    #     };
    #   };
    # };
    # defaultGateway = {
    #   address = "10.0.0.1";
    #   interface = "eth0";
    # };
    # timeServers = [
    #   "10.0.0.1"
    # ];
    # firewall.enable = false;
  };

  time.timeZone = "Europe/Berlin";

  users.users.ndo = {
    initialPassword = "test";
    description = "ndo";
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirt" "kvm" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/ndom91.keys";
        sha256 = "PfSNkhnNXUR9BTD2+0An2ugQAv2eYipQOFxQ3j8XD5Y=";
      }))
    ];
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    openssh
  ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
      };
    };
  };

  # systemd services
  systemd.services.systemd-udevd.restartIfChanged = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-networkd-wait-online.enable = false;

  hardware = {
    enableAllFirmware = true;
  };

  system.stateVersion = "23.11";
}
