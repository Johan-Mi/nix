{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations.e14g6 = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./configuration/graphical.nix
        ./hardware/e14g6.nix
      ];
    };
    nixosConfigurations.tyko = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./hardware/tyko.nix
      ];
    };
    homeConfigurations."johanmi@e14g6" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        ./home.nix
        ./home/e14g6.nix
        ./home/graphical.nix
      ];
      extraSpecialArgs = { inherit inputs; };
    };
    homeConfigurations."johanmi@tyko" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        ./home.nix
      ];
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
