{
  description = "NixOS configuration with flakes";
  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:pjones/plasma-manager";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, plasma-manager }: {
    nixosConfigurations.frametop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        nixos-hardware.nixosModules.framework-13-7040-amd
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.rileyb = import ./home.nix;
          home-manager.sharedModules =
            [ plasma-manager.homeManagerModules.plasma-manager ];
        }
      ];
    };
  };
}
