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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAbAylECwZpvAOEq69apq5J1OAAF3ka TebhuqOps2O7WoJCCylqzu7rrPAun2tE3tsjeqwEdFMjSXYxBQowp5b0HiAT6w1Mtwy6Pg jnQW5/VOsTYpg1dl3hw1ZiRYa1yUT+xfVba4+POEKXizpMjL8xlkW/ugnj2WL8O85QplqI GRRIsSAa4jBsZ3d1j88iSv0ZFpTXdTuf9EISNFBrIXq7f+JyhtGZqaj4m67CNoxPiadfyX 7XrgVKra8/SaYa00RebI4V+tp6NDhJL6LZN8rX2O1a7O6NCUhZ1avYw4aY00kMyGqx2bR5 5ml7jN9k/edaKqHJInff8cPefa45ub ndo@ndo4"
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
