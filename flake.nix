{
  description = "ndom91 flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-needtoreboot.url = "github:thefossguy/nixos-needsreboot";
    nixos-needtoreboot.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&tag=v0.45.2";
    # hyprland.url = "github:hyprwm/Hyprland/v0.45.2";
    hyprland.url = "github:hyprwm/Hyprland/v0.47.2";
    # hyprland.url = "github:hyprwm/Hyprland";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";
    nixcord.url = "github:kaylorben/nixcord";

    # Applications
    ghostty.url = "github:ghostty-org/ghostty"; # Terminal Emulator
    superfile.url = "github:MHNightCat/superfile"; # Terminal File Manager
    tsui.url = "github:guibou/tsui/fix_nix_run"; # Tailsccale TUI
    isd.url = "github:isd-project/isd"; # Interactive SystemD
  };

  outputs = { self, unstable, catppuccin, agenix, nix-colors, nixpkgs, nix-index-database, ... } @inputs:
    let
      stateVersion = "24.11";
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        system = system;
        overlays = [ (self: super: { utillinux = super.util-linux; }) ];
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
