<img align="right" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg" width="128px" />

# NixOS Configs

## 🏗️Overview

Consists mostly of a rebuild of my [dotfiles](https://github.com/ndom91/dotfiles) into a flake and a few other nixos related configurations.

![](./dotfiles/screenshot.png)

## 📦 Packages

Some configured packages include:

- hyprland
- vivaldi
- wezterm
- slack
- neovim
- tmux

## 📂 Directories

- `flake.nix` - Entrypoint
- `modules/home-manager` - User applications, configuration, and packages
- `modules/nixos` - System-wide modules and configuration
- `hosts/*` - Host specific configurations

## 📝 License

MIT
