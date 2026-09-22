{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, lanzaboote, ... }: {
    nixosConfigurations."0xvoid" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        lanzaboote.nixosModules.lanzaboote
	./configuration.nix 
      ];
    };
  };
}
