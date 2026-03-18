{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
  };

  outputs = { nixpkgs, home-manager, disko, ... } @ inputs:
  let hosts = [ "e14g6" "tyko" ];
      username = "johanmi"; in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts (host: nixpkgs.lib.nixosSystem {
      modules = [
        (./hardware + "/${host}.nix")
        ./configuration.nix
        (./configuration + "/${host}.nix")
      ];
      specialArgs = { inherit disko username; };
    });
    homeConfigurations = builtins.listToAttrs (builtins.map (host: {
      name = "${username}@${host}";
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./home.nix
          (./home + "/${host}.nix")
        ];
        extraSpecialArgs = { inherit inputs username; };
      };
    }) hosts);
  };
}
