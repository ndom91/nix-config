# Netboot Testing VM

VM for testing booting from the network.

## 🚀 Quick Start

First, you need to build the VM image. Ensure the `.result/bin` directory exists and has a script named `run-ndo4-vm` in it. Once built, you can run the start script to boot the VM with `qemu`.

```bash
./vm-build.sh
./vm-start.sh --nographic
```

## 📝 Notes

- https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html
