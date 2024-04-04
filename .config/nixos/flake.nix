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
    nixpkgs-iosevka-pin.url =
      "github:nixos/nixpkgs/7848d6f048d38c42a8aeeff7fe7d36916ffb8284";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, plasma-manager
    , nixpkgs-iosevka-pin }:
    let
      vars = {
        username = "rileyb";
        hostname = "frametop";
      };
    in {
      nixosConfigurations.${vars.hostname} = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs vars;
          pkgs-iosevka-pin = import nixpkgs-iosevka-pin {
            system = system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./configuration.nix
          # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useUserPackages = true;
            home-manager.users.${vars.username} = import ./home.nix;
            home-manager.sharedModules =
              [ plasma-manager.homeManagerModules.plasma-manager ];
          }
        ];
      };
    };
}
