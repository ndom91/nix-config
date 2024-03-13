{
  description = "ndom91 config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    hyprland.url = "github:hyprwm/hyprland";
    # hyprland-contrib = {
    #   url = "github:hyprwm/contrib";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

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
                permittedInsecurePackages = [ "electron-25.9.0" ]; # For `unstablePkgs.protonvpn-gui`
              };
              localSystem = { inherit system; };
            };
          };
          modules = [
            ./hosts/ndo4/configuration.nix
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
                permittedInsecurePackages = [ "electron-25.9.0" ];
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
