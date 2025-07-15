{
  description = "ndom91 flake";
  inputs = {
    pkgs2505.url = "github:nixos/nixpkgs/nixos-25.05";
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

    flake-input-patcher.url = "github:jfly/flake-input-patcher";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-needtoreboot.url = "github:thefossguy/nixos-needsreboot";
    nixos-needtoreboot.inputs.nixpkgs.follows = "nixpkgs";

    # Applications
    hyprland.url = "github:hyprwm/Hyprland";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    isd.url = "github:isd-project/isd"; # Interactive SystemD TUI
    ghostty.url = "github:ghostty-org/ghostty"; # Terminal Emulator
    # ghostty.url = "github:ghostty-org/ghostty?ref=v1.1.3"; # Terminal Emulator
    # superfile.url = "github:MHNightCat/superfile"; # Terminal File Manager
    # tsui.url = "github:guibou/tsui/fix_nix_run"; # Tailsccale TUI
    # nixcord = {
    #   url = "github:kaylorben/nixcord";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # }; # Discord Client
  };

  outputs = { self, unstable, nixpkgs, ... } @inputs:
    let
      stateVersion = "25.05";
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

      # TODO: Patch Ghostty to fix caps:esc override bug (https://github.com/ghostty-org/ghostty/discussions/7356)
      # patcher = unpatchedInputs.flake-input-patcher.lib.x86_64-linux;
      #
      # inputs = patcher.patch unpatchedInputs {
      #   # Patching a direct dependency:
      #   ghostty.patches = [
      #     (patcher.fetchpatch {
      #       url = "path:/etc/nixos/modules/home-manager/ghostty_capsesc.patch";
      #       # url = "file:///etc/nixos/modules/home-manager/ghostty_capsesc.patch";
      #     })
      #   ];
      # };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        ndo4 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs unstablePkgs stateVersion;
          };
          modules = [
            ./hosts/ndo4/configuration.nix
            ./packages/protonvpn-wg-quick/default.nix
            inputs.nix-index-database.nixosModules.nix-index
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
          ];
        };
        ndo-gb = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs unstablePkgs stateVersion;
          };
          modules = [
            ./hosts/ndo-gb/configuration.nix
            ./packages/protonvpn-wg-quick/default.nix
            inputs.nix-index-database.nixosModules.nix-index
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
          ];
        };
        ndo2 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs unstablePkgs stateVersion;
          };
          modules = [
            ./hosts/ndo2/configuration.nix
            inputs.nix-index-database.nixosModules.nix-index
            inputs.agenix.nixosModules.default
            inputs.catppuccin.nixosModules.catppuccin
          ];
        };
      };
    };
}
