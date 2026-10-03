{
  description = "snowflake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs = inputs@{ self, nixpkgs, lanzaboote, home-manager, ... }: {
    nixosConfigurations."0xvoid" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        lanzaboote.nixosModules.lanzaboote
	      ./hosts/0xvoid/configuration.nix
        home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.slepykotek = ./hosts/0xvoid/home.nix;
          }
      ];
    };
  };
}
