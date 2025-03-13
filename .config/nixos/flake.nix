{
  description = "NixOS configuration with flakes";

  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

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
      url = "github:nix-community/plasma-manager";
    };

    # Pin Iosevka to a specific nixpkgs commit to prevent lots of long builds
    nixpkgs-iosevka-pin.url = "github:nixos/nixpkgs/ac35b104800bff9028425fec3b6e8a41de2bbfff";

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    # Neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      plasma-manager,
      nixpkgs-iosevka-pin,
      rust-overlay,
      nil,
      neovim-nightly-overlay,
    }:
    let
      vars = {
        username = "rileyb";
        hostname = "frametop";
        system = "x86_64-linux";
        version = "23.11";
      };
    in
    {
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
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
          }
        ];
      };
      devShells.${vars.system}.python =
        let
          pkgs = import nixpkgs { system = vars.system; };
          python = pkgs.python312;
          pythonPackages = python.pkgs;
          lib-path = pkgs.lib.makeLibraryPath [
            pkgs.libffi
            pkgs.openssl
            pkgs.stdenv.cc.cc
            pkgs.zlib
          ];

        in
        pkgs.mkShell {
          packages = [
            pythonPackages.numpy
          ];

          buildInputs = [
            pkgs.openssl
            pkgs.git
          ];

          shellHook = ''
            SOURCE_DATE_EPOCH=$(date +%s)
            export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
            export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"
            VENV=.venv

            if test ! -d $VENV; then
              python -m venv $VENV
            fi
            source ./$VENV/bin/activate
            export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
            pip install -r requirements.txt
          '';

          postShellHook = ''
            ln -sf ${python.sitePackages}/* ./.venv/lib/python3.12/site-packages
          '';
        };

    };
}
