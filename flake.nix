{
  description = "ndom91 flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&tag=v0.43.0";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nix-colors.url = "github:misterio77/nix-colors";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    superfile.url = "github:MHNightCat/superfile";
    # playwright.url = "github:kalekseev/nixpkgs/playwright-core";
    tsui.url = "github:guibou/tsui/fix_nix_run";
  };

  outputs = { self, unstable, agenix, nix-colors, nixpkgs, nix-index-database, ... } @inputs:
    let
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "24.05";
      system = "x86_64-linux";

      # playwrightOverlay = final: prev: {
      #   inherit (inputs.playwright.packages.${prev.system})
      #     playwright-driver playwright-test;
      # };

      pkgs = import nixpkgs {
        system = system;
        # overlays = [ playwrightOverlay ];
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
          ];
        };
      };
    };
}
