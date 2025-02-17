{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dwmblocks.url = "github:Johan-Mi/dwmblocks";
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: {
    homeConfigurations = let system = "x86_64-linux"; in {
      "johanmi" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs system; };
      };
    };
  };
}
