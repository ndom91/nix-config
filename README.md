<img align="right" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg" width="128px" />

# NixOS Configs

## 🏗️Overview

This repository started off with my preexisting [dotfiles](https://github.com/ndom91/dotfiles) and then morphed into a flake containing the applications and configuration of all of my personal machines.

![](./dotfiles/screenshot.png)

## 📂 Directories

- `flake.nix` - Entrypoint
- `modules/home-manager` - User applications, configuration, and packages
- `modules/nixos` - System-wide modules and configuration
- `hosts/*` - Host specific configurations

## 📝 License

MIT
