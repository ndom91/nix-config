{
  description = "ndom91 config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=cba1ade848feac44b2eda677503900639581c3f4";
    hyprfocus = {
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # nix-gaming.url = "github:fufexan/nix-gaming";

    nix-colors.url = "github:misterio77/nix-colors";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.1.0";
    # superfile = {
    #   url = "github:MHNightCat/superfile";
    # };
  };

  outputs = { self, unstable, agenix, nix-colors, nixpkgs, ... } @inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstablePkgs = unstable.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        ndo4 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit nix-colors;
            unstablePkgs = import unstable {
              config = {
                allowUnfree = true;
              };
              localSystem = { inherit system; };
            };
          };
          modules = [
            ./hosts/ndo4/configuration.nix
            ./packages/protonvpn-wg-quick/default.nix
            agenix.nixosModules.default
          ];
        };
        ndo2 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit nix-colors;
            unstablePkgs = import unstable {
              config = {
                allowUnfree = true;
              };
              localSystem = { inherit system; };
            };
          };
          modules = [
            ./hosts/ndo2/configuration.nix
            agenix.nixosModules.default
          ];
        };
      };
    };
}
