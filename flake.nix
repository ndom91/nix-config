{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        ndo4 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; nix-colors; };
          modules = [
            ./hosts/ndo4/configuration.nix
          ];
        };
        ndo2 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; nix-colors; };
          modules = [
            ./hosts/ndo2/configuration.nix
          ];
        };
      };
    };
}
