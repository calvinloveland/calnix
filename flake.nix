{
  description = "Calvin's Linux";
  inputs = {
    # User's nixpkgs - for user packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kickstart-nixvim = {
      url = "github:JMartJonesy/kickstart.nixvim?rev=0f52b918fb80af38cbe5cb4d883b94758a5d99d4";
    };
  };
  outputs = {nixpkgs, ... }@inputs:{
    HOSTNAME = "Thinker";
    nixosConfigurations.Thinker = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
