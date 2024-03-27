{
  description = "NixOS configuration with flakes";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations.frametop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        nixos-hardware.nixosModules.framework-13-7040-amd
      ];
    };
  };
}
