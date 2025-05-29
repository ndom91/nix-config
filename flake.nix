{
  description = "ndom91 flake";
  inputs = {
    pkgs2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-needtoreboot.url = "github:thefossguy/nixos-needsreboot";
    nixos-needtoreboot.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&tag=v0.45.2";
    # hyprland.url = "github:hyprwm/Hyprland/v0.47.2";
    hyprland.url = "github:hyprwm/Hyprland";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";
    # nixcord = {
    #   url = "github:kaylorben/nixcord";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Applications
    ghostty.url = "github:ghostty-org/ghostty?ref=v1.1.3"; # Terminal Emulator
    isd.url = "github:isd-project/isd"; # Interactive SystemD
    # superfile.url = "github:MHNightCat/superfile"; # Terminal File Manager
    # tsui.url = "github:guibou/tsui/fix_nix_run"; # Tailsccale TUI
  };

  outputs = { self, unstable, catppuccin, agenix, nix-colors, nixpkgs, nix-index-database, pkgs2411, ... } @inputs:
    let
      stateVersion = "24.11";
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        system = system;
      };

      unstablePkgs = import unstable {
        config = {
          allowUnfree = true;
        };
        localSystem = { inherit system; };
      };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        ndo4 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nix-colors unstablePkgs stateVersion;
          };
          modules = [
            ./hosts/ndo4/configuration.nix
            ./packages/protonvpn-wg-quick/default.nix
            nix-index-database.nixosModules.nix-index
            agenix.nixosModules.default
            catppuccin.nixosModules.catppuccin
          ];
        };
        ndo-gb = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nix-colors unstablePkgs stateVersion;
          };
          modules = [
            ./hosts/ndo-gb/configuration.nix
            ./packages/protonvpn-wg-quick/default.nix
            nix-index-database.nixosModules.nix-index
            agenix.nixosModules.default
            catppuccin.nixosModules.catppuccin
          ];
        };
        ndo2 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nix-colors unstablePkgs stateVersion;
          };
          modules = [
            ./hosts/ndo2/configuration.nix
            nix-index-database.nixosModules.nix-index
            agenix.nixosModules.default
            catppuccin.nixosModules.catppuccin
          ];
        };
      };
    };
}
