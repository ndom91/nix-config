{
  description = "A generic and minimal netbooting OS for my homelab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        generic = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
        };
      };
      # packages.${system}.netboot = nixpkgs.legacyPackages.${system}.symlinkJoin {
      #   name = "netboot";
      #   paths = with self.nixosConfigurations.generic.config.system.build; [
      #     netbootRamdisk
      #     kernel
      #     netbootIpxeScript
      #   ];
      #   preferLocalBuild = true;
      # };
    };
}
