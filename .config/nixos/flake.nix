{
  description = "NixOS configuration with flakes";
  inputs = {
    # Main nixpkgs source
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    # Up-to-date hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Declarative KDE Plasma configuration
    plasma-manager = {
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:pjones/plasma-manager";
    };

    # Pin Iosevka to a specific nixpkgs commit to prevent lots of long builds
    nixpkgs-iosevka-pin.url =
      "github:nixos/nixpkgs/7848d6f048d38c42a8aeeff7fe7d36916ffb8284";

    # This will already be installed by other flake inputs anyway, may as well
    # include it so we can prevent accidental package duplication in the
    # future (using `follows`)
    flake-utils.url = "github:numtide/flake-utils";

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, plasma-manager
    , nixpkgs-iosevka-pin, rust-overlay, nil, flake-utils }:
    let
      vars = {
        username = "rileyb";
        hostname = "frametop";
        system = "x86_64-linux";
        version = "23.11";
      };
    in {
      nixosConfigurations.${vars.hostname} = nixpkgs.lib.nixosSystem rec {
        system = "${vars.system}";
        specialArgs = {
          inherit inputs vars;
          pkgs-iosevka-pin = import nixpkgs-iosevka-pin {
            system = system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./configuration.nix
          # NOTE: add your model from this list:
          # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
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
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            # TODO: Install this user-wide instead of system-wide?
            environment.systemPackages = [
              (pkgs.rust-bin.stable.latest.default.override {
                extensions = [ "rust-analyzer" "rust-src" ];
              })
            ];
          })
        ];
      };
    };
}
